# First Peoples' Language Map

Django backend and Vue frontend for the First Peoples' Language Map.

License: Apache License 2.0

The previous project documentation is available in [LEGACY_README.md](LEGACY_README.md).

---

## Developer setup

These instructions run the Django application directly on Apple Silicon macOS. Docker is not required.

### 1. Clone the repository

```sh
git clone https://github.com/First-Peoples-Cultural-Council/maps.git
cd maps
```

### 2. Install prerequisites

Install [Homebrew](https://brew.sh/) and [pyenv](https://github.com/pyenv/pyenv), then run:

```sh
brew update
brew install pyenv postgresql@17 postgis gdal geos
pyenv install -s 3.11.13
```

This project uses PostgreSQL port `5433` so it can run alongside another PostgreSQL version. Open the PostgreSQL 17 configuration file:

```sh
open -e "$(brew --prefix)/var/postgresql@17/postgresql.conf"
```

Set the port and save the file:

```conf
port = 5433
```

Start PostgreSQL and verify it is ready:

```sh
brew services start postgresql@17
"$(brew --prefix postgresql@17)/bin/pg_isready" -h 127.0.0.1 -p 5433
```

The readiness check should report `accepting connections`.

For other operating systems, install Python 3.11, PostgreSQL 17, PostGIS, GDAL, and GEOS using the package instructions for your platform. Update the paths and database port in `.env` as needed.

### 3. Create the virtual environment

Create one virtual environment at the repository root:

```sh
"$(pyenv root)/versions/3.11.13/bin/python" -m venv .venv
source .venv/bin/activate
python -m pip install --upgrade pip setuptools wheel
python -m pip install -r web/requirements.txt
```

### 4. Configure the environment

```sh
cp .env.example .env
```

The example contains the verified Homebrew paths and local database settings. Replace the Cognito placeholders with development values from a project maintainer if you need authentication. The server can start with the placeholders.

The `.env` file is ignored by Git. Do not commit secrets.

### 5. Create the database

Create a local-only PostgreSQL role and database:

```sh
PG_BIN="$(brew --prefix postgresql@17)/bin"
"$PG_BIN/createuser" -h 127.0.0.1 -p 5433 --superuser maps_local
"$PG_BIN/createdb" -h 127.0.0.1 -p 5433 --owner=maps_local maps_local
```

The role is a superuser so it can create PostGIS extensions and restore database dumps. Use this configuration for local development only.

Choose one of the following data setup options.

#### Option A: Start with an empty database

```sh
cd web
../.venv/bin/python manage.py migrate
cd ..
```

#### Option B: Restore a database dump

Place the custom-format dump at `db.sql` in the repository root. Restore it into the new, empty database:

```sh
PG_BIN="$(brew --prefix postgresql@17)/bin"
"$PG_BIN/pg_restore" \
  -h 127.0.0.1 \
  -p 5433 \
  -U maps_local \
  -d maps_local \
  --no-owner \
  --no-acl \
  --exit-on-error \
  db.sql
```

The current production dump may leave one `django_apscheduler` migration unapplied because it contains duplicate historical scheduler records. This warning does not prevent the development server or application APIs from running.

### 6. Verify the setup

```sh
cd web
../.venv/bin/python manage.py check --database default
```

The command should report `System check identified no issues`.

### 7. Start Django

From the `web` directory:

```sh
../.venv/bin/python manage.py runserver
```

The application is available at:

- Admin: <http://127.0.0.1:8000/admin/>
- Language API: <http://127.0.0.1:8000/api/language/>

Stop the server with `Control-C`.

To stop or restart PostgreSQL 17:

```sh
brew services stop postgresql@17
brew services start postgresql@17
```

## Create an admin user

With the virtual environment active, run from the `web` directory:

```sh
../.venv/bin/python manage.py createsuperuser
```
