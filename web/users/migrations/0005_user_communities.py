# Generated by Django 2.2.4 on 2019-08-28 20:59

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0064_auto_20190828_2057'),
        ('users', '0004_remove_user_communities'),
    ]

    operations = [
        migrations.AddField(
            model_name='user',
            name='communities',
            field=models.ManyToManyField(through='language.CommunityMember', to='language.Community'),
        ),
    ]
