# Generated by Django 2.2.8 on 2020-04-14 14:28

from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0117_relateddata_label'),
    ]

    operations = [
        migrations.RenameField(
            model_name='relateddata',
            old_name='private',
            new_name='is_private',
        ),
    ]
