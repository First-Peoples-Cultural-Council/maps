# First People's Language Map

This is a web map that helps explore Indigenous language data.

## Technology Stack Overview

-   Fully Dockerized, and configured with docker-compose.
-   Uses PostgreSQL and PostGIS.
-   API-Driven Django. We don't use Django's templates for anything.
-   Uses Nuxt.js for SEO-friendly modern templates.
-   Proxies all ports through port 80, the default, including websockets, so there's no need to worry about the port of anything when developing.

## Installation

Clone the project.

```
git clone https://github.com/countable-web/fplm.git
```

Install [Docker](https://docs.docker.com/install/) and [docker-compose](https://docs.docker.com/compose/install/).

Copy the local settings template. They're all in one file, dc.dev.yml. docker-compose.override.yml is gitignored so you can store secrets there if needed.
```
cp dc.dev.yml docker-compose.override.yml
```

Spin up the project.

```
docker-compose up
```

Your Django app is served at `http://localhost/api`

To create a superuser, do this from the shell.

```
docker-compose exec web ./setup.sh
```

You can visit the Django admin at `http://localhost/admin` and sign in with your superuser. The username is `admin`, password is `pass`.

Your Vue app is served at `http://localhost`. The front-end won't work properly unless you have a realistic dataset. In this project, the database is quite small, we suggest using a production snapshot for development, because this gives better dev/prod parity for easier development. The other option is to populate tables using a script (an example is provided for migrating out of Druapl) or create your data manually in the Django admin.

## Contributing

To work on a feature locally, configure your editor to use the `black` code style for Python, and the `prettier` style for Javascript, HTML and CSS. Use the local `.pretterrc` file. If you ever have coding style problems, you can fix them by running:

```
docker-compose exec frontend lint --fix
```

### Example, add a new database field.

Open one of the `models.py`, and add your field according to the [docs](https://docs.djangoproject.com/en/2.2/topics/db/models/), ie) (new line marked with `+`)

```
class Language(BaseModel)

+    flavour=CharField(default='Strawberry', max_length=31)
    other_names = models.TextField(default="", blank=True)
    fv_archive_link = models.URLField(max_length=255, blank=True, default="")
```

Then create, and apply the migration. Make sure you add the generated migration to GIT.
```
docker-compose exec web python manage.py makemigrations
docker-compose exec web python manage.py migrate
git add .
```

If you want this field to be editable in the admin, this will happen by default. Depending on the previous rules, you may need to edit (admin.py)[https://docs.djangoproject.com/en/2.2/ref/contrib/admin/]


## Restoring data

This project was originally ported from a Drupal database, and we have a somewhat generic way of getting things out of Drupal the first time. Doing this requires populating the old database secrets in your docker-compose.override.yml

`docker-compose exec web python manage.py bootstrap` to get languages.
`docker-compose exec web python manage.py get_sleeping` to import an old KML source for languageion region geometry (included in repo).
`docker-compose exec web python manage.py cache_arts` and `docker-compose exec web python manage.py load_arts` to get arts.


## Testing

To test frontend:
```
        docker-compose exec frontend yarn run test
```

To test backend API:
```
        docker-compose exec web python manage.py test
```


