# Generated by Django 2.2.8 on 2020-06-02 10:42

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0096_auto_20191230_2011'),
    ]

    operations = [
        migrations.AlterField(
            model_name='community',
            name='email',
            field=models.EmailField(blank=True, default=None, max_length=255, null=True),
        ),
        migrations.AlterField(
            model_name='community',
            name='nation_id',
            field=models.IntegerField(blank=True, null=True),
        ),
    ]
