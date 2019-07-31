# First People's Language Map

## Installation

Clone the project.

Install Docker and docker-compose.

Copy the local settings template. They're all in one file, dc.dev.yml. docker-compose.override.yml is gitignored so you can store secrets there if needed.
```
cp dc.dev.yml docker-compose.override.yml
```

Spin up the project.

```
docker-compose up
```

Your Django app is served at `http://localhost/api`

To create a superuser:

```
docker-compose exec web ./setup.sh
```

You can visit the Django admin at `http://localhost/admin`. The username is `admin`, password is `pass`.

Your Vue app is served at `http://localhost`. The front-end won't work properly unless you have a realistic dataset. In this project, the database is quite small, we suggest using a production snapshot for development, because this gives better dev/prod parity for easier development. The other option is to populate tables using a script (an example is provided for migrating out of Druapl) or create your data manually in the Django admin.

## Contributing

To work on a feature locally, we suggest restoring a database dump. 

## Features

-   Fully Dockerized, and configured with docker-compose
-   Uses PostgreSQL
-   API-Driven Django. We don't use Django's templates for anything.
-   Uses Nuxt.js
-   Proxies all ports through port 80, the default, including websockets, so there's no need to worry about the port of anything when developing.

## Restoring data

`docker-compose exec web python manage.py bootstrap` to get languages.

## Import arts 

`docker-compose exec web python manage.py load_arts`


## Front End

For development: 

        For fixing Module Error (from ./node_modules/eslint-loader/index.js): 

                docker-compose exec frontend yarn lint --fix

To build & start for production:

        docker-compose exec frontend bash
        yarn run build
        yarn start

To test frontend:

        docker-compose exec frontend yarn run test

## Back End

To test backend API:

        docker-compose exec web python manage.py test


# Code Formatting / Standard

Code is formatted with Black (for Python), Vetur for Vue, with Prettier for HTML and JS. In your editor, configure Vetur with its HTML formatter set to Prettier (not the default) to avoid linter errors later.
