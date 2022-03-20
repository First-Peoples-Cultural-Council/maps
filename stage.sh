#!/bin/bash

cp dc.stage.yml docker-compose.override.yml
docker-compose up -d --build
sleep 180
docker-compose restart nginx frontend

