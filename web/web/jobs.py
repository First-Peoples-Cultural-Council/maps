import random
import time
import sys

from apscheduler.schedulers.background import BackgroundScheduler
from django_apscheduler.jobstores import DjangoJobStore, register_events, register_job
from language.notifications import send

scheduler = BackgroundScheduler()
scheduler.add_jobstore(DjangoJobStore(), "default")
from arts.management.commands.load_arts import sync_arts


@register_job(
    scheduler,
    "cron",
    # second="*",
    misfire_grace_time=60
    * 60
    * 20,  # This is set to 20 hours to give plenty of time to run missed jobs the same day, but avoid them overrunning into the following day.
    second=0,
    minute=0,
    hour=2,
    day="*",
    replace_existing=True,
)
def notifier_job():
    send()

@register_job(
    scheduler,
    "cron",
    # second="*",
    misfire_grace_time=60
    * 60
    * 20,  # This is set to 20 hours to give plenty of time to run missed jobs the same day, but avoid them overrunning into the following day.
    second=0,
    minute=0,
    hour=3,
    day="*",
    replace_existing=True,
)
def arts():
    sync_arts()


register_events(scheduler)

# uncomment the end of this line to test scheduling on dev envs.
if "gunicorn" in "".join(sys.argv):  # or "runserver" in sys.argv:
    scheduler.start()
    print("Scheduler started!")
