from rest_framework.decorators import api_view
from .management.commands.cache_arts import Client
from rest_framework.response import Response
from language.models import Language

import os
import json


@api_view()
def all(request):
    if not os.path.exists("web/static/web/arts1.json"):
        open("web/static/web/arts1.json", "w").write(json.dumps(Client().update()))
    arts = json.loads(open("web/static/web/arts1.json", "r").read())

    # if "lang" in request.GET:
    #     languages=Language.objects.get(pk=request.GET.get("lang"))
    #     language.geom.contains()
    return Response(arts)
