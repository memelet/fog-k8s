#!/bin/zsh

# Get the admin token
LOGIN_URI=https://rancher.127-0-0-1.nip.io:7202/v3-public/localProviders/local?action=login
token=$(curl --silent --insecure -X POST "${LOGIN_URI}" --data '{"username": "admin", "password": "rancher"}' | jq -r '.token')
echo "** token: ($?, $token)"

# Set server URL
SERVER_URL_URI=https://rancher.127-0-0-1.nip.io:7202/v3/settings/server-url
curl --insecure -X PUT "${SERVER_URL_URI}" \
-H "Authorization: Bearer ${token}" \
--data '{"id": "server-url", "name": "server-url", "baseType": "setting", "type": "setting", "value": "https://rancher.127-0-0-1.nip.io"}'
