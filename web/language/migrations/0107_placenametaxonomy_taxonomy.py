# Generated by Django 2.2.8 on 2020-03-20 13:09

from django.db import migrations, models
import django.db.models.deletion


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0106_auto_20200318_2222'),
    ]

    operations = [
        migrations.CreateModel(
            name='Taxonomy',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('name', models.CharField(max_length=100, unique=True)),
                ('description', models.TextField(default='')),
                ('parent', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='language.Taxonomy')),
            ],
        ),
        migrations.CreateModel(
            name='PlaceNameTaxonomy',
            fields=[
                ('id', models.AutoField(auto_created=True, primary_key=True, serialize=False, verbose_name='ID')),
                ('placename', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='language.PlaceName')),
                ('taxonomy', models.ForeignKey(null=True, on_delete=django.db.models.deletion.SET_NULL, to='language.Taxonomy')),
            ],
        ),
    ]
