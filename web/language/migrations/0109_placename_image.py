# Generated by Django 2.2.8 on 2020-03-24 18:38

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0108_placename_taxonomies'),
    ]

    operations = [
        migrations.AddField(
            model_name='placename',
            name='image',
            field=models.ImageField(default=None, null=True, upload_to=''),
        ),
    ]
