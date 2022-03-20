#!/bin/bash

cp dc.prod.yml docker-compose.override.yml
docker-compose up -d --build
sleep 180
docker-compose restart nginx frontend

