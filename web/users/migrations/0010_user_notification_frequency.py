# Generated by Django 2.2.4 on 2019-09-23 10:24

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('users', '0009_user_last_notified'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='notification_frequency',
            field=models.IntegerField(default=7),
        ),
    ]
