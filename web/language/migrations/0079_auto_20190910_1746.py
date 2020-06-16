# Generated by Django 2.2.4 on 2019-09-10 17:46

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0078_auto_20190910_0157'),
    ]

    operations = [
        migrations.AlterField(
            model_name='media',
            name='description',
            field=models.TextField(blank=True, default=''),
        ),
        migrations.AlterField(
            model_name='media',
            name='file_type',
            field=models.CharField(default=None, max_length=16, null=True),
        ),
        migrations.AlterField(
            model_name='media',
            name='status_reason',
            field=models.TextField(blank=True, default=''),
        ),
        migrations.AlterField(
            model_name='placename',
            name='status_reason',
            field=models.TextField(blank=True, default=''),
        ),
    ]
