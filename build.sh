#!/bin/bash

docker build -t docker.pkg.github.com/hellerphilipp/tivok-api/tivok-api:0.1 .
docker push docker.pkg.github.com/hellerphilipp/tivok-api/tivok-api:0.1