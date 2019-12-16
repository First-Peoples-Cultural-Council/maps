from html.parser import HTMLParser
import json, sys

C=json.loads(open(sys.argv[1]).read())

out = {
  "type": "FeatureCollection",
  "features": []
}
kind=sys.argv[1].split('.')[0]

for c in C:
    f = {"type":"Feature"}
    f['geometry'] = json.loads(c['geoJSON'])
    f['properties'] = {"kind": kind}
    if 'color' in c:
        f['properties']['color'] = c['color']
    if 'title' in c:
        f['properties']['title'] = c['title']
    elif 'popup' in c:
        f['properties']['title'] = HTMLParser().unescape(c['popup'].split('>')[1].split('<')[0])
    elif 'description' in c:
        f['properties']['title'] = HTMLParser().unescape(c['description'].split('>')[1].split('<')[0])
    out['features'].append(f)

print(json.dumps(out))

