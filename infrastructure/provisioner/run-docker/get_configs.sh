#!/bin/bash

shopt -s expand_aliases
source ~/.bash_aliases

mkdir -p ~/gatewise/secrets/web

# web tokens
cat << EOF > ~/gatewise/secrets/web/app.env
REFRESH_TOKEN=$(aws secretsmanager get-secret-value --secret-id gatewise/web --query SecretString --output=text | jq -r '.refresh_token')
USER_AGENT=$(aws secretsmanager get-secret-value --secret-id gatewise/web --query SecretString --output=text | jq -r '.user_agent')
DEVICE_TOKEN=$(aws secretsmanager get-secret-value --secret-id gatewise/web --query SecretString --output=text | jq -r '.device_token')
KEY=$(aws secretsmanager get-secret-value --secret-id gatewise/web --query SecretString --output=text | jq -r '.key')
EOF

# set proper permissions for secrets 700 for dir and 600 for files
chmod -R u=rwX,g=,o= ~/gatewise/secrets




