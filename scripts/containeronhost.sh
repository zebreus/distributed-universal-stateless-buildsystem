#!/bin/sh
set eux
NAME=$(yq -r '.name' resource.yml)
COMMAND=$(yq '.task.command' resource.yml)
crun spec --rootless
jq '.root={"path":"res","readonly":false}' config.json > config2.json
mv config2.json config.json
jq '.process.args=["sh","-c", '"$COMMAND"' ]' config.json > config2.json
mv config2.json config.json
crun run "$NAME"

