#!/bin/sh
set eux
URL=$(yq '.task.source' resource.yml | tr -d '"')
FILENAME=$(yq '.task.filename' resource.yml | tr -d '"') 
if test "$FILENAME" = "null"
then
    FILENAME=$(basename "$URL")
fi
echo $FILENAME
mkdir -p res
wget -O "res/$FILENAME" "$URL"
