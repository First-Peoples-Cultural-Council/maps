# Generated by Django 2.2.3 on 2019-07-16 19:32

import django.contrib.gis.db.models.fields
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0030_auto_20190716_1929'),
    ]

    operations = [
        migrations.AlterField(
            model_name='language',
            name='geom',
            field=django.contrib.gis.db.models.fields.PolygonField(default=None, null=True, srid=4326),
        ),
    ]
