# Generated by Django 5.2 on 2025-04-23 15:39

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('backend_app', '0014_hotel'),
    ]

    operations = [
        migrations.RemoveField(
            model_name='hotel',
            name='image_url',
        ),
        migrations.AddField(
            model_name='hotel',
            name='image',
            field=models.ImageField(blank=True, default=None, max_length=200, null=True, upload_to='hotels/'),
        ),
    ]
