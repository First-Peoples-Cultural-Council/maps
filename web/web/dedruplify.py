import pymysql
import os
from decimal import Decimal
from datetime import datetime
import json


class DeDruplifierClient:
    def query(self, sql):
        with self.db.cursor() as cursor:
            cursor.execute(sql)
            results = cursor.fetchall()
        return results

    def map_drupal_items(self, drupal_table, LocalTable, mapping={}):
        items = []
        drupal_data = json.loads(open("tmp/%s.json" % drupal_table).read())
        for pk, rec in drupal_data.items():
            # print(rec)
            try:
                item = LocalTable.objects.get(name=rec["title"])
            except LocalTable.DoesNotExist:
                item = LocalTable(name=rec["title"])
            for k, v in mapping.items():
                if k in rec:  # missing from data.
                    if k.endswith("target_id"):

                        FKTable = getattr(LocalTable, v).field.related_model
                        try:
                            obj = FKTable.objects.get(name=rec[k + "_title"][0])
                            setattr(item, v, obj)
                        except FKTable.DoesNotExist:
                            print(k, "with pk", rec[k + "_title"], "does not exist")
                        except KeyError:
                            print("WARN:", rec, "has no", k + "_title")
                    elif k.endswith("_lat"):
                        pt = Point(rec[k[:-4] + "_lon"][0], rec[k][0])
                        setattr(item, v, pt)
                    else:
                        if len(rec[k]) > 1:
                            print(v, "has", len(rec[k]))
                            setattr(item, v, ",".join(rec[k]))
                        else:
                            setattr(item, v, rec[k][0])
            item.save()
            items.append((rec, item))
            # print('saved', item)
        return items

    def map_taxonomy(self):
        """
        Schema is:
        #     CREATE TABLE `taxonomy_index` (
        # `nid` int(10) unsigned NOT NULL DEFAULT '0',
        # `tid` int(10) unsigned NOT NULL DEFAULT '0',
        # `sticky` tinyint(4) DEFAULT '0',
        # `created` int(11) NOT NULL DEFAULT '0',
        """
        self.tax_terms = self.query("select * from taxonomy_term_data;")
        """
        CREATE TABLE `taxonomy_term_data` (
          `tid` int(10) unsigned NOT NULL AUTO_INCREMENT,
          `vid` int(10) unsigned NOT NULL DEFAULT '0',
          `name` varchar(255) NOT NULL DEFAULT '',
          `description` longtext,
          `weight` int(11) NOT NULL DEFAULT '0' COMMENT 'The weight of this term in relation to other terms.',
          `format` varchar(255) DEFAULT NULL COMMENT 'The filter_format.format of the description.',
          `uuid` char(36) NOT NULL DEFAULT '' COMMENT 'The Universally Unique Identifier.',
          PRIMARY KEY (`tid`),
          KEY `vid_name` (`vid`,`name`),
          KEY `name` (`name`),
          KEY `taxonomy_tree` (`vid`,`weight`,`name`),
          KEY `uuid` (`uuid`)
        ) ENGINE=InnoDB AUTO_INCREMENT=150 DEFAULT CHARSET=utf8;
        /*!40101 SET character_set_client = @saved_cs_client */;
        """
        term_mappings = self.query("select * from taxonomy_index;")
        # TODO: make generic.

    def __init__(self, host, user, pw, db, file_site=None):
        self.db = pymysql.connect(
            host, user, pw, db, cursorclass=pymysql.cursors.DictCursor
        )
        self.file_site = file_site

    def update(self):
        os.makedirs("tmp/files", exist_ok=True)

        """
        DeDruplify - remove the Drupal node schema with foreign fields and save flat JSON
        """
        nodes = self.query("select * from node;")
        _nodes = {}
        _by_id = {}
        for node in nodes:
            # "nid": 273, "vid": 330, "type": "tm_language", "language": "und", "title": "Wakashan", "uid": 1, "status": 1, "created": 1372273871, "changed": 1372273871, "comment": 0, "promote": 0, "sticky": 0, "tnid": 0, "translate": 0, "uuid"
            new_node = {"type": node["type"], "title": node["title"]}
            if node["type"] not in _nodes:
                _nodes[node["type"]] = {}
            _nodes[node["type"]][node["nid"]] = new_node
            _by_id[node["nid"]] = new_node
        for k, v in _nodes.items():
            print("type:", k, len(v))
        tables = [r["Tables_in_{}".format(db)] for r in self.query("show tables;")[:]]

        _files = {}
        # download files.
        if file_site:
            for row in self.query("select * from file_managed"):
                print(row)
                uri = row["uri"].replace("public://", "")
                _files[row["fid"]] = uri
                output_filename = os.path.join("tmp/files", uri)
                output_dir = os.path.dirname(output_filename)
                os.makedirs(output_dir, exist_ok=True)
                cmd = "wget https://maps.fpcc.ca/sites/default/files/{} -P {}".format(
                    uri, output_dir
                )
                print(cmd)
                if not os.path.exists(output_filename):
                    os.system(cmd)
            # download from https://maps.fpcc.ca/sites/default/files/<path>

        """
        mysql> select * from field_revision_field_tm_champ_link;
        +-------------+----------+---------+-----------+-------------+----------+-------+-------------------------+---------------------------+--------------------------------+
        | entity_type | bundle   | deleted | entity_id | revision_id | language | delta | field_tm_champ_link_url | field_tm_champ_link_title | field_tm_champ_link_attributes |
        +-------------+----------+---------+-----------+-------------+----------+-------+-------------------------+---------------------------+--------------------------------+
        | node        | tm_champ |       0 |      3476 |        3843 | und      |     0 | http://www.chrispaul.ca | NULL                      | a:0:{}                         |
        +-------------+----------+---------+-----------+-------------+----------+-------+-------------------------+---------------------------+--------------------------------+
        1 row in set (0.08 sec)
        """

        # flatten these dynamic fields into nice object lists.
        # man, what were we thinking in the late 90s...
        for table in tables:
            if table.startswith("field_data_"):
                print(table, "being loaded.")
                for row in self.query("select * from %s" % table):
                    if row["entity_type"] != "node":
                        continue

                    for k, v in row.items():
                        if (
                            k.startswith("field_")
                            or "value" in k
                            and not k.endswith("_format")
                        ):
                            if type(v) is bytes:
                                # print('ignoring bytes', v)
                                continue
                            elif type(v) is Decimal:
                                v = float(v)
                            elif type(v) is datetime:
                                v = v.isoformat()
                            target = _nodes[row["bundle"]][row["entity_id"]]
                            if k not in target:
                                target[k] = []
                            if v not in target[k]:  # add unique values to the list
                                target[k].append(v)

        # remap foreign keys using natural values (node titles)

        for pk, rec in _by_id.items():
            # print(rec)
            tmp = {}
            tmp.update(rec)
            for k, v in tmp.items():

                # files
                if k.endswith("_fid") and file_site:
                    print(k, rec[k])
                    newval = [_files[v[0]]]
                    rec[k + "_filename"] = newval
                # other fields
                if k.endswith("target_id"):
                    rec[k + "_title"] = []
                    rec[k + "_type"] = []
                    for item in v:
                        if item in _by_id:
                            rec[k + "_title"].append(_by_id[item]["title"])
                            rec[k + "_type"].append(_by_id[item]["type"])
                        else:
                            rec[k + "_title"].append(None)
                            rec[k + "_type"].append(None)

        for typ, data in _nodes.items():
            # print(typ)

            open("tmp/{}.json".format(typ), "w").write(
                json.dumps(data, indent=4, sort_keys=True)
            )
