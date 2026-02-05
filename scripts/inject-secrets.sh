#!/bin/bash
# Creates LOCAL.postman_environment.json from specified environment
# Usage: ./inject-secrets.sh [DEV|QA|PROD]

set -e

ENV="${1:-DEV}"

if [[ ! "$ENV" =~ ^(DEV|QA|PROD)$ ]]; then
  echo "Error: Invalid environment '$ENV'. Must be DEV, QA, or PROD"
  exit 1
fi

if [ "$ENV" = "PROD" ]; then
  ENV_FILE=".env"
else
  ENV_FILE=".env.$(echo "$ENV" | tr '[:upper:]' '[:lower:]')"
fi

if [ -f "$ENV_FILE" ]; then
  echo "Loading credentials from ${ENV_FILE}..."
  export $(cat "$ENV_FILE" | grep -v '^#' | xargs)
else
  echo "Error: ${ENV_FILE} not found!"
  exit 1
fi

if [ -z "$GOREST_AUTH_TOKEN" ] || [ -z "$REQRES_API_KEY" ]; then
  echo "Error: GOREST_AUTH_TOKEN and REQRES_API_KEY must be set in ${ENV_FILE}"
  exit 1
fi

if [ ! -f "environments/${ENV}.postman_environment.json" ]; then
  echo "Error: environments/${ENV}.postman_environment.json not found!"
  exit 1
fi

echo "Using ${ENV} environment as base..."

cat "environments/${ENV}.postman_environment.json" | \
  sed 's/"name": "'"$ENV"'"/"name": "LOCAL"/' | \
  sed 's/"value": "YOUR_AUTH_TOKEN_HERE"/"value": "'"$GOREST_AUTH_TOKEN"'"/' | \
  sed 's/"value": "YOUR_REQRES_API_KEY_HERE"/"value": "'"$REQRES_API_KEY"'"/' \
  > environments/LOCAL.postman_environment.json

echo "Created LOCAL.postman_environment.json from ${ENV} with credentials from ${ENV_FILE}"
