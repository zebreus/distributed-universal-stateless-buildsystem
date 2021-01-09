#!/bin/sh
set eux
URL=$(yq '.task.source' resource.yml | tr -d '"')
git clone --recursive "$URL" res
