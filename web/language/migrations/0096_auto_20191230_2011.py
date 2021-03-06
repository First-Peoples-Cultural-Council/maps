# Generated by Django 2.2.8 on 2019-12-30 20:11

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('language', '0095_placename_audio'),
    ]

    def transfer_audio_files(apps, schema_editor):
        
        # get PlaceName and Recording models
        Recording = apps.get_model('language', 'Recording')
        PlaceName = apps.get_model('language', 'PlaceName')
        
        # run raw query to fetch users
        from django.db import connection
        cursor = connection.cursor()
        # execute query
        cursor.execute('''SELECT id FROM language_placename 
                        where audio_file is not null and audio_file <> '' and audio_id is null 
                        order by id''')
        # fetch all objects
        placenames = cursor.fetchall()

        # iterate over all users objects
        for place in placenames:

            placename_id = place[0]

            # print placename object
            # print('------' + str(placename_id) + '------')
            
            placename = PlaceName.objects.get(pk=placename_id)

            # create Recording object from users object
            # (keeping the folder media/audio_files/place_names, 
            # so no file needs to be moved to media folder)
            record = Recording.objects.create(
                        audio_file=placename.audio_file,
                    )

            # # create Recording object from users object
            # # (changing the folder to media folder. 
            # # Files need to be moved on the server)
            # record = Recording.objects.create(
            #             audio_file=str(placename.audio_file).replace('audio_files/place_names/',''),
            #         )
            
            placename.audio = record
            placename.save()

            # break

        # raise Exception('Nothing really')

    operations = [
        migrations.AlterField(
            model_name='recording',
            name='date_recorded',
            field=models.DateField(null=True, verbose_name='date recorded'),
        ),
        migrations.AlterField(
            model_name='recording',
            name='recorder',
            field=models.CharField(max_length=255, null=True),
        ),
        migrations.AlterField(
            model_name='recording',
            name='speaker',
            field=models.CharField(max_length=255, null=True),
        ),
        # run function for transferring data
        migrations.RunPython(transfer_audio_files),
    ]
