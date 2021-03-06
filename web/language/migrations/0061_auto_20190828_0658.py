# Generated by Django 2.2.4 on 2019-08-28 06:58

from django.conf import settings
from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        migrations.swappable_dependency(settings.AUTH_USER_MODEL),
        ('language', '0060_remove_mediafavourite_user'),
    ]

    operations = [
        migrations.AddField(
            model_name='placename',
            name='community',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='language.Community'),
        ),
        migrations.AddField(
            model_name='placename',
            name='language',
            field=models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='language.Language'),
        ),
        migrations.CreateModel(
            name='CommunityMember',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('status', models.CharField(choices=[('UN', 'Unverified'), ('VE', 'Verified'), ('RE', 'Rejected')], default='UN', max_length=2)),
                ('community', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to='language.Community')),
                ('user', models.ForeignKey(default=None, null=True, on_delete=django.db.models.deletion.CASCADE, to=settings.AUTH_USER_MODEL)),
            ],
            options={
                'verbose_name_plural': 'Community Members',
            },
        ),
    ]
