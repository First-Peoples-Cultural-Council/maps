# Generated by Django 2.2.4 on 2019-08-18 20:23

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('web', '0002_auto_20190818_1912'),
    ]

    operations = [
        migrations.AlterField(
            model_name='page',
            name='name',
            field=models.CharField(default='', max_length=255, unique=True, verbose_name='Traditional Name'),
        ),
    ]
