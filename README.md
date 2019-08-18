# First People's Language Map

This is a web map that helps explore Indigenous language data. This README file includes new materials added in Milestone 2. [See Milestone 1 deliverables here](./README-MILESTONE1.md).

## Technology Stack Overview

- Fully Dockerized, and configured with docker-compose.
- Uses PostgreSQL and PostGIS.
- API-Driven Django. We don't use Django's templates for anything.
- Uses Nuxt.js for SEO-friendly modern templates.
- Proxies all ports through port 80, the default, including websockets, so there's no need to worry about the port of anything when developing.

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

## Public API

To get all languages:

```
curl http://maps-dev.fpcc.ca/api/language/
```

Details or a specific language:

```
curl http://maps-dev.fpcc.ca/api/language/18/
```

To get all communities:

```
curl http://maps-dev.fpcc.ca/api/community/
```

Details or a specific community:

```
curl http://maps-dev.fpcc.ca/api/community/18/
```

## Updating Domain Data Via API

Three endpoints are available to update directly, via API: `/api/language/`, `/api/community`, and `api/stats`.

First, you should authenticate your API client as an FPCC admin user. For example using `curl`:

```
curl --request POST --header "Content-Type: application/json" \
    --data '{"username": "admin", "password": "********"}' http://localhost/api-token-auth/
```

This will return a token, such as `{"token":"cfc2b213a4adfbae02332fbbfb45ec09e56413a4"}`

Then, you can call the API using the returned token in your authorization header. For example, first load your data using the public API to ensure you're changing the right objects, as in the above section and update some field using a PATCH request. This request will not clear other unspecified fields so it's useful for making corrections.

```
curl --request PATCH --header "Content-Type: application/json" \
    --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
    --data '{"regions": "Kootenays"}' http://localhost/api/language/18/
```

To create a new object, use POST, for example a new Community:

```
curl --request POST --header "Content-Type: application/json" --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
    --data '{"name":"Heiltsuk Nation New","champion_ids": [22], "language_ids":[27],"sleeping":false,"other_names":"Heiltsuk,Bella Bella,Heiltsuk-Oweekala","regions":"","audio_file":null, "english_name":"","other_names":"Heiltsuk Band","internet_speed":"","population":0,"point":{"type":"Point","coordinates":[-128.145551,52.160363]},"email":"admin@example.net","website":"http://www.bellabella.net","phone":"","alt_phone":"(250) 999-9999","fax":"(250) 999-9999"}' http://localhost/api/community/
```

There is an important difference between the objects you can write and read from APIs. We have opted for an "atomic" API, meaning that related objects are referenced by ID. So, to set the language of a community, you would do:

```
curl --request PATCH --header "Content-Type: application/json" \
    --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
    --data '{"language_ids": [18]}' http://localhost/api/community/255/
```

Even though what is returned includes the entire language object inline, not just its ID: ```
{"id":253,"name":"Halfway River First Nations","languages":[{"name":"Dakelh (ᑕᗸᒡ)","id":18,"color":"RGB(0, 208, 104)","bbox"... }]}

````

Our API writes objects "atomically", meaning only one database row can be edited or added per request. This is to help make the API simple and predicable (simple consistent CRUD for each table), as writing inline objects (while convenient) can lead to nontrivial edge cases. (For example, we need conventions on whether to assume anything not included in a PATCH is to be deleted from the set, modified if it includes updates, and should those modifications follow PATCH conventions as well...). For a small single-purpose writable API that wasn't part of our project focus, the atomic method is predictable and simple, allowing our focus to be on other scope.

Lastly, to upload an audio file to a language or other object, make a separate PATCH request, not using JSON, but just the default raw for encoding: ```
curl  --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" --request PATCH -sS http://localhost/api/language/18/ -F 'audio_file=@./test.mp3'
````

## Contributing

To work on a feature locally, configure your editor to use the `black` code style for Python, and the `prettier` style for Javascript, HTML and CSS. Use the local `.pretterrc` file. If you ever have coding style problems, you can fix them by running:

```

docker-compose exec frontend lint --fix

```

### Example, add a new database field.

Open one of the `models.py`, and add your field according to the [docs](https://docs.djangoproject.com/en/2.2/topics/db/models/), ie) (new line marked with `+`)

```

class Language(BaseModel)

- flavour=CharField(default='Strawberry', max_length=31)
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

## Deployment

The `master` branch is deployed by Jenkins to production, `maps.fpcc.ca` by default.
The `develop` branch id deployed by Jenkins to staging, `maps-dev.fpcc.ca` by default.

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

```

```
