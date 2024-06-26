# First People's Language Map

This is a web map that helps explore Indigenous language data. This README file includes new materials added in Milestones 3 and 2 of this project. [See Milestone 1 deliverables here](./README-MILESTONE1.md).

## Technology Stack Overview

- Fully Dockerized, and configured with docker-compose.
- Uses PostgreSQL and PostGIS.
- API-Driven Django. We don't use Django's templates for anything.
- Uses Nuxt.js for SEO-friendly modern templates.
- Proxies all ports through port 80, the default, including websockets, so there's no need to worry about the port of anything when developing.

## Installation

Clone the project.

```
git clone https://github.com/First-Peoples-Cultural-Council/fplm.git
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

Your Vue app is served at `http://localhost`. The front-end won't work properly unless you have a realistic dataset. In this project, the database is quite small, we suggest using a production snapshot for development, because this gives better dev/prod parity for easier development. The other option is to populate tables using a script (an example is provided for migrating out of Druapl) or create your data manually in the Django admin.

Acquire a database dump. If the file is `db.sql` in your repo root, do:

```
./docs/restore-pg
```

For loading arts data in your local environment, acquire a database dump for the data in `fp-artsmap.ca`. If the file is `arts.sql` in your repo root, follow the instructions below:

- Add another service in your docker-compose.override.yml with the following data:
    ```
    arts_db:
        image: mysql
        environment:
            MYSQL_ROOT_PASSWORD: mysql
            MYSQL_USER: mysql
            MYSQL_DATABASE: arts
            MYSQL_PASSWORD: mysql
            MYSQL_ROOT_HOST: '%'
        networks:
            - back-tier
        volumes:
            - mysqldb-files:/var/lib/mysql
    ```
- Add volume for the new service:
    ```
    volumes:
        ...
        mysqldb-files:
            driver: local
    ```
- Run the command below in another terminal to start the new service without stopping the others:
    ```
    docker-compose up -d
    ```
- Restore the `arts.sql` dump:
    ```
    docker cp arts.sql maps_arts_db_1:/tmp
    docker-compose exec arts_db bash
    cd /tmp
    mysql -u mysql -p arts < arts.sql
    ```
- Trigger load_arts command in web:
    ```
    docker-compose exec web python manage.py load_arts
    ```

## Deployment

  * We auto-deploy the `master` branch of `https://github.com/First-Peoples-Cultural-Council/maps` to `https://maps.fpcc.ca` nightly.
  * We auto-deploy the `develop` branch of `https://github.com/countable-web/maps` to `http://maps.fpcc.ca:8080` nightly.

## Public API

To get all languages:

```
curl http://maps.fpcc.ca/api/language/
```

Details or a specific language:

```
curl http://maps.fpcc.ca/api/language/18/
```

To get all communities:

```
curl http://maps.fpcc.ca/api/community/
```

Details or a specific community:

```
curl http://maps.fpcc.ca/api/community/18/
```

## Updating Domain Data Via API

API Documentation is available at localhost/api/docs
Three endpoints are available to update directly, via API: `/api/language/`, `/api/community`, and `api/stats`.

First, you should authenticate your API client as an FPCC admin user. For example using `curl`:

```
curl --request POST --header "Content-Type: application/json" \
    --data '{"username": "admin", "password": "********"}' http://maps.fpcc.ca/api-token-auth/
```

This will return a token, such as `{"token":"cfc2b213a4adfbae02332fbbfb45ec09e56413a4"}`

Then, you can call the API using the returned token in your authorization header. For example, first load your data using the public API to ensure you're changing the right objects, as in the above section and update some field using a PATCH request. This request will not clear other unspecified fields so it's useful for making corrections.

```
curl --request PATCH --header "Content-Type: application/json" \
    --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
    --data '{"regions": "Kootenays"}' http://maps.fpcc.ca/api/language/18/
```

To create a new object, use POST, for example a new Community:

```
curl --request POST --header "Content-Type: application/json" --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
    --data '{"name":"Heiltsuk Nation New","champion_ids": [22], "language_ids":[27],"sleeping":false,"other_names":"Heiltsuk,Bella Bella,Heiltsuk-Oweekala","regions":"","audio_file":null, "english_name":"","other_names":"Heiltsuk Band","internet_speed":"","population":0,"point":{"type":"Point","coordinates":[-128.145551,52.160363]},"email":"admin@example.net","website":"http://www.bellabella.net","phone":"","alt_phone":"(250) 999-9999","fax":"(250) 999-9999"}' http://maps.fpcc.ca/api/community/
```

To add some stats:

```
curl --request POST --header "Content-Type: application/json" --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" --data '{ "fluent_speakers": 2, "semi_speakers": 3, "active_learners": 4, "language": 18, "community":255}' http://maps.fpcc.ca/api/stats/

```

To create a new Recording, use POST:

```
curl --header "Authorization: Token a213aeb9e9fc723511c37096e69f72822391aae4" --request POST -sS http://maps.fpcc.ca/api/recording/ -H 'Content-Type: multipart/form-data;' -F 'speaker=speaker name' -F 'date_recorded=2010-10-10' -F 'recorder=recorder name' -F 'audio_file=@/home/denis/demonyms.txt'

```

To add an existing Recording as a Language audio, use PATCH:

```
curl --header "Authorization: Token a213aeb9e9fc723511c37096e69f72822391aae4" --request PATCH -sS http://maps.fpcc.ca/api/language/26/add_language_audio/ --header "Content-Type: application/json"  --data '{ "recording_id": 41 }'

```

To add an existing Recording as a Language greeting audio, use PATCH:

```
curl --header "Authorization: Token a213aeb9e9fc723511c37096e69f72822391aae4" --request PATCH -sS http://maps.fpcc.ca/api/language/26/add_greeting_audio/ --header "Content-Type: application/json"  --data '{ "recording_id": 41 }'

```

To add an existing Recording as a Community audio, use PATCH:

```
curl --header "Authorization: Token a213aeb9e9fc723511c37096e69f72822391aae4" --request PATCH -sS http://maps.fpcc.ca/api/community/206/add_audio/ --header "Content-Type: application/json"  --data '{ "recording_id": 41 }'

```

There is an important difference between the objects you can write and read from APIs. Related object collections are referenced as a list of IDs, with the `_ids` suffix. So, to set the language of a community, you would do:

```

curl --request PATCH --header "Content-Type: application/json" \
 --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" \
 --data '{"language_ids": [18]}' http://maps.fpcc.ca/api/community/255/

```

Even though what is returned includes the entire language object inline, not just its ID:

```
{"id":253,"name":"Halfway River First Nations","languages":[{"name":"Dakelh (ᑕᗸᒡ)","id":18,"color":"RGB(0, 208, 104)","bbox"... }]}

```

Lastly, to upload an audio file to a language or other object, make a separate PATCH request, not using JSON, but just the default raw for encoding:

```
curl --header "Authorization: Token cfc2b213a4adfbae02332fbbfb45ec09e56413a4" --request PATCH -sS http://localhost/api/language/18/ -F 'audio_file=@./test.mp3'

```

_The API writes objects "atomically", meaning only one database row can be edited or added per request. This is to help make the API simple and predicable (simple consistent CRUD for each table), as writing inline objects (while convenient) can lead to nontrivial edge cases. (For example, we need conventions on whether to assume anything not included in a PATCH is to be deleted from the set, modified if it includes updates, and should those modifications follow PATCH conventions as well...). For a small single-purpose writable API that wasn't part of our project focus, the atomic method is predictable and simple, allowing our focus to be on other scope._

## Contributing

To work on a feature locally, configure your editor to use the `black` code style for Python, and the `prettier` style for Javascript, HTML and CSS. Use the local `.pretterrc` file. If you ever have coding style problems, you can fix them by running:

```

docker-compose exec frontend yarn lint --fix

```

Vscode settings for automatic linting
```
"eslint.validate": [
    {
    "language": "vue",
    "autoFix": true
    },
    {
    "language": "javascript",
    "autoFix": true
    },
    {
    "language": "javascriptreact",
    "autoFix": true
    }
],
"eslint.autoFixOnSave": true,
"editor.formatOnSave": false,
"vetur.validation.template": false,
"editor.fontSize": 16,
"terminal.integrated.scrollback": 50000
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

Done via GitHub Actions

`.github/workflows/cd-prod.yml` - The `master` branch is deployed by GitHub Actions to production, `maps.fpcc.ca` by default.
Only the `https://github.com/First-Peoples-Cultural-Council/maps` has GH Action Secrets for this deployment set up, as follows.
```
PROD_ENVS= # populate the local.env.template file provided.
KNOWN_HOSTS= # `ssh-keyscan <production server>` output
PROD_DEPLOY_KEY= # private key of producion server
```

`.github/workflows/cd-stage.yml` - The `develop` branch is deployed by GitHub Actions to staging, `fplm.countable.ca` by default.
Only the countable-web fork has secrets set to deploy here, as follows.
```
KNOWN_HOSTS= # `ssh-keyscan <stage server>` output
BOOL= # private key of staging server
```

## Bootstrapping data (Not necessary to run again)

This project was originally ported from a Drupal database, and we have a somewhat generic way of getting things out of Drupal the first time. Doing this requires populating the old database secrets in your docker-compose.override.yml

`docker-compose exec web python manage.py bootstrap` to get languages.
`docker-compose exec web python manage.py get_sleeping` to import an old KML source for languageion region geometry (included in repo).
`docker-compose exec web python manage.py load_arts` to get arts.

#### Categories
To import categories from the csv file found at /web/fixtures/categories.csv run the following command:
```
docker-compose exec web python manage.py get_categories
```

## Testing

To test frontend:

The docker container is by default on sleep. Need to comment out `command: sleep 1000000` on `docker-compose.override.yml` then restart the container.
The test container is dependant on the frontend and the web container, and make sure these are running

```

docker-compose up test

```

To test backend API:

```

docker-compose exec web python manage.py test

```

## Linting

### Python

We use pylint to detect linting errors in Python. Disclaimer: pylint is only used to detect errors an does not automatically fix them. Linting fixes have to be manually applied by the developer.

```
# Linting for entire folder
docker-compose exec web sh pylint.sh <folder_name>

# Linting for specific file
docker-compose exec web sh pylint.sh <folder_name>/<file_name>/
```

### Notifications

The system sends users notifications weekly, including:

- new contributions (places and media) in their profile's selected language/community.
- when other users "favourite" their contributions.
- requests to approve/verify contributions (only language admins receive this)

The user is only notified of each event once, as determined by their `last_notified` attribute (see web/users/models.py).

To send a test notification email:

```

docker-compose exec web python manage.py test_notifications --email <email of user> --days <number of days>

```

Specifying a number days (integer) will always force-send updates the specified number of days of updates, regardless of whether those updates have already been sent.
