# Generated by Django 2.2.8 on 2020-05-26 13:43

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0119_placename_owner'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='placename',
            name='owner',
        ),
    ]
