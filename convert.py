import json

C=json.loads(open('langs.raw').read())

out = {
  "type": "FeatureCollection",
  "features": []
}

for c in C:
    f = {"type":"Feature"}
    f['geometry'] = json.loads(c['geoJSON'])
    f['properties'] = {'title':c['title'],'color':c['color']}
    out['features'].append(f)

print(json.dumps(out))

