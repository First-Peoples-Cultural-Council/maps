import random
import time
import sys

from apscheduler.schedulers.background import BackgroundScheduler
from django_apscheduler.jobstores import DjangoJobStore, register_events, register_job
from language.notifications import send

scheduler = BackgroundScheduler()
scheduler.add_jobstore(DjangoJobStore(), "default")


@register_job(scheduler, "interval", seconds=300, replace_existing=True)
def notifier_job():
    send()


register_events(scheduler)
if "gunicorn" in sys.argv or "runserver" in sys.argv:
    scheduler.start()
    print("Scheduler started!")
