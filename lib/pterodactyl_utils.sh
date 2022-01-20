#!/bin/bash
source ${SCRIPT_DIR}/config/pterodactyl_config

send_pterodactyl_client_api_request() {
  local endpoint=$1
  local method=$2
  local body=$3

  local url="${PTERODACTYL_API_HOST}/api/client/${endpoint}"

  curl "${url}" \
    -H "Accept: application/json" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${PTERODACTYL_CLIENT_API_KEY}" \
    -X "${method}" \
    -d "${body}" \
    --silent \
    --show-error
}

send_command_to_pterodactyl_server() {
  local server_id=$1
  local command=$2

  echo ${command}

  send_pterodactyl_client_api_request \
    "servers/${server_id}/command" \
    "POST" \
    "{\"command\": \"${command}\"}"
}
