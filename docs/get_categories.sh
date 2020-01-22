#!/bin/bash

# Get the local database container address and store it
ADDRESS=$(docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' "$(docker-compose ps -q db)")

# Run the python script to import the categories to the database at the address passed in
docker-compose exec web python manage.py get_categories $ADDRESS