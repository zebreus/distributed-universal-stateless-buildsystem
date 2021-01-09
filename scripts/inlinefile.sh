#!/bin/sh
set eux
FILE=$(yq -r '.task.path' resource.yml)
CONTENT=$(yq -r '.task.content'  resource.yml)
mkdir -p res
echo "$CONTENT" > "res/$FILE"
