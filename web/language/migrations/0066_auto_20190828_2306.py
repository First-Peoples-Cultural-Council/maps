# Generated by Django 2.2.4 on 2019-08-28 23:06

from django.conf import settings
from django.db import migrations


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('language', '0065_mediafavourite_user'),
    ]

    operations = [
        migrations.RenameModel(
            old_name='MediaFavourite',
            new_name='Favourite',
        ),
    ]
