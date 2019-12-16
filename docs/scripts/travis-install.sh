#!/bin/sh
sudo apt-get update
sudo apt-get install -y libproj-dev gdal-bin libpq-dev libpython3-dev \
    default-libmysqlclient-dev build-essential
echo "installed OS deps"
cd web
pip install -r requirements.txt
