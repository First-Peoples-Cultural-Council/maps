# Generated by Django 2.2.8 on 2020-05-30 08:18

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0121_auto_20200530_0816'),
    ]

    operations = [
        migrations.AlterField(
            model_name='taxonomy',
            name='order',
            field=models.IntegerField(blank=True, default=None, help_text='Value that determines the ordering of taxonomy. The lower the value is, the higher it is on the list', null=True),
        ),
    ]