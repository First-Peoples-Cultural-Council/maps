# Generated by Django 2.2.3 on 2019-07-12 07:06

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0016_auto_20190712_0701'),
    ]

    operations = [
        migrations.CreateModel(
            name='CommunityLink',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('website', models.URLField(default=None, max_length=255, null=True)),
                ('title', models.CharField(max_length=255)),
                ('community', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='language.Community')),
            ],
        ),
    ]