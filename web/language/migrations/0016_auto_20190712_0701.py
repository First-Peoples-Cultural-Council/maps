# Generated by Django 2.2.3 on 2019-07-12 07:01

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0015_placename_kind'),
    ]

    operations = [
        migrations.AddField(
            model_name='community',
            name='alt_phone',
            field=models.CharField(default='', max_length=255),
        ),
        migrations.AddField(
            model_name='community',
            name='fax',
            field=models.CharField(default='', max_length=255),
        ),
        migrations.AddField(
            model_name='community',
            name='other_names',
            field=models.CharField(default='', max_length=255),
        ),
        migrations.AddField(
            model_name='community',
            name='phone',
            field=models.CharField(default='', max_length=255),
        ),
    ]
