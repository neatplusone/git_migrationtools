#!/bin/bash

GITHUB_USERNAME=
GITHUB_TOKEN=
GITHUB_ORGANISATION=

GITEA_USERNAME=
GITEA_TOKEN=
GITEA_DOMAIN=
GITEA_REPO_OWNER=

GET_REPOS=$(curl -H 'Accept: application/vnd.github.v3+json' -u $GITHUB_USERNAME:$GITHUB_TOKEN -s "https://api.github.com/orgs/$GITHUB_ORGANISATION/repos?per_page=200&type=all" | jq -r '.[].html_url')

for URL in $GET_REPOS; do

    REPO_NAME=$(echo $URL | sed 's|https://github.com/$GITHUB_ORGANISATION/||g')

    echo "Found $REPO_NAME, importing..."

    curl -X POST "https://$GITEA_DOMAIN/api/v1/repos/migrate" -u $GITEA_USERNAME:$GITEA_TOKEN -H  "accept: application/json" -H  "Content-Type: application/json" -d "{  \
    \"auth_username\": \"$GITHUB_USERNAME\", \
    \"auth_password\": \"$GITHUB_TOKEN\", \
    \"clone_addr\": \"$URL\", \
    \"mirror\": false, \
    \"private\": true, \
    \"repo_name\": \"$REPO_NAME\", \
    \"repo_owner\": \"$GITEA_REPO_OWNER\", \
    \"service\": \"git\", \
    \"uid\": 0, \
    \"wiki\": true}"

done
