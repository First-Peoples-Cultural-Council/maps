from rest_framework.decorators import api_view
from .management.commands.cache_arts import Client
from rest_framework.response import Response

import os
import json


@api_view()
def all(request):
    if not os.path.exists('tmp/arts.json'):
        open('tmp/arts.json', 'w').write(json.dumps(Client().update()))
    return Response(json.loads(open('tmp/arts.json', 'r').read()))
