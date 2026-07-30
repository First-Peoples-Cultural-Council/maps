from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ("language", "0142_auto_20231113_0627"),
    ]

    operations = [
        migrations.AlterUniqueTogether(
            name="communitymember",
            unique_together=set(),
        ),
        migrations.AddConstraint(
            model_name="communitymember",
            constraint=models.UniqueConstraint(
                fields=("user", "community"),
                name="unique_community_member",
            ),
        ),
    ]
