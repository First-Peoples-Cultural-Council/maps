# Generated by Django 2.2.8 on 2020-03-18 17:45

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0104_remove_media_node_id'),
    ]

    operations = [
        migrations.CreateModel(
            name='ArtArtist',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('art', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='art_artists', to='language.PlaceName')),
                ('artist', models.ForeignKey(on_delete=django.db.models.deletion.CASCADE, related_name='artist_arts', to='language.PlaceName')),
            ],
        ),
    ]