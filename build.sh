#!/bin/bash
docker build -t akadrac/social-track app/.
docker container run --name temp-container-name akadrac/social-track /bin/true
docker container cp temp-container-name:/tmp/app.zip dist/app.zip
docker container rm temp-container-name
