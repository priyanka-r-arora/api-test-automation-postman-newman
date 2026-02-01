#!/bin/bash

# Copies DEV.postman_environment.json to LOCAL and replaces 
# placeholder values with .env values

set -e

# Load environment variables from .env file
if [ -f .env ]; then
  export $(cat .env | grep -v '^#' | xargs)
else
  echo "Error: .env file not found!"
  exit 1
fi

# Check if required variables are set
if [ -z "$GOREST_AUTH_TOKEN" ] || [ -z "$REQRES_API_KEY" ]; then
  echo "Error: GOREST_AUTH_TOKEN and REQRES_API_KEY must be set in .env file"
  exit 1
fi

# Check if DEV environment file exists
if [ ! -f environments/DEV.postman_environment.json ]; then
  echo "Error: environments/DEV.postman_environment.json not found!"
  exit 1
fi

# Copy DEV environment to LOCAL and replace values
cat environments/DEV.postman_environment.json | \
  sed 's/"name": "DEV"/"name": "LOCAL"/' | \
  sed 's/"value": "YOUR_AUTH_TOKEN_HERE"/"value": "'"$GOREST_AUTH_TOKEN"'"/' | \
  sed 's/"value": "YOUR_REQRES_API_KEY_HERE"/"value": "'"$REQRES_API_KEY"'"/' \
  > environments/LOCAL.postman_environment.json

echo "Created LOCAL.postman_environment.json with credentials from .env"
