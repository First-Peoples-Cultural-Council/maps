import pymysql
from django.core.management.base import BaseCommand, CommandError
from language.models import Language, Community

import os
import sys
import json
from decimal import Decimal
from datetime import datetime


class DedruplifierClient:

    def query(self, sql):
        with self.db.cursor() as cursor:
            cursor.execute(sql)
            results = cursor.fetchall()
        return results

    def update(self):
        self.db = pymysql.connect(
            os.environ['FPLM_HOST'],
            os.environ['FPLM_USER'],
            os.environ['FPLM_PW'],
            os.environ['FPLM_DB'],
            cursorclass=pymysql.cursors.DictCursor)

        """
        DeDruplify - remove the Drupal node schema with foreign fields and save flat JSON
        """
        nodes = self.query("select * from node;")
        _nodes = {}
        for node in nodes:
            # "nid": 273, "vid": 330, "type": "tm_language", "language": "und", "title": "Wakashan", "uid": 1, "status": 1, "created": 1372273871, "changed": 1372273871, "comment": 0, "promote": 0, "sticky": 0, "tnid": 0, "translate": 0, "uuid"
            new_node = {
                'type': node['type'],
                'title': node['title'],
            }
            if node['type'] not in _nodes:
                _nodes[node['type']] = {}
            _nodes[node['type']][node['nid']] = new_node

        for k, v in _nodes.items():
            print('type:', k, len(v))

        tables = [r['Tables_in_fpmaps_d7_live']
                  for r in self.query("show tables;")[:]]

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
            if table.startswith('field_revision_field_'):
                print(table, 'being loaded.')
                for row in self.query('select * from %s' % table):
                    if row['entity_type'] != 'node':
                        continue

                    for k, v in row.items():
                        if 'field_' in k:
                            if type(v) is bytes:
                                continue
                            elif type(v) is Decimal:
                                v = float(v)
                            elif type(v) is datetime:
                                v = v.isoformat()
                            _nodes[row['bundle']][row['entity_id']][k] = v

        for typ, data in _nodes.items():
            print(typ)

            open('tmp/{}.json'.format(typ),
                 'w').write(json.dumps(data, indent=4, sort_keys=True))

    def load(self):
        regions = json.loads(open('tmp/tm_language_region.json').read())
        for pk, region in regions.items():
            print(region)
            try:
                l = Language.objects.get(name=region['title'])
            except Language.DoesNotExist:
                l = Language(name=region['title'])

            l.save()

        communities = json.loads(open('tmp/tm_language_region.json').read())
        for pk, community in communities.items():
            print(community)
            try:
                l = Community.objects.get(name=community['title'])
            except Language.DoesNotExist:
                l = Community(name=community['title'])

            l.save()


class Command(BaseCommand):
    help = 'Closes the specified poll for voting'

    def handle(self, *args, **options):

        c = DedruplifierClient()
        c.update()
        c.load()
