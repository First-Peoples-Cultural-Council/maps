# Generated by Django 2.2.4 on 2019-09-06 22:18

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0073_auto_20190905_0353'),
    ]

    operations = [
        migrations.RenameField(
            model_name='placename',
            old_name='western_name',
            new_name='common_name',
        ),
    ]
