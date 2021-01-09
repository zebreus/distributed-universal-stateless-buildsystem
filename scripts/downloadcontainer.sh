#!/bin/sh
set eux
CONTAINER=$(yq '.task.source' resource.yml | tr -d '"')
docker pull "$CONTAINER"
docker save "$CONTAINER" | undocker -o res
