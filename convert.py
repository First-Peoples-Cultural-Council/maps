from html.parser import HTMLParser
import json, sys

C=json.loads(open(sys.argv[1]).read())

out = {
  "type": "FeatureCollection",
  "features": []
}

for c in C:
    f = {"type":"Feature"}
    f['geometry'] = json.loads(c['geoJSON'])
    f['properties'] = {}
    if 'title' in c:
        f['properties']['title'] = c['title']
    if 'color' in c:
        f['properties']['color'] = c['color']
    if 'popup' in c:
        f['properties']['popup'] = HTMLParser().unescape(c['popup'].split('>')[1].split('<')[0])
    if 'description' in c:
        f['properties']['description'] = HTMLParser().unescape(c['description'].split('>')[1].split('<')[0])
    out['features'].append(f)

print(json.dumps(out))

