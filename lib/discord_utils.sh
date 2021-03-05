#!/bin/bash
source ${SCRIPT_DIR}/config/discord_config

send_message_to_discord() {
  local text=$1
  local username=$2

  if [[ -z ${username} ]]; then
    ${SCRIPT_DIR}/lib/vendor/discord.sh --webhook-url="$DISCORD_WEBHOOK" --text "${text}"
  else
    ${SCRIPT_DIR}/lib/vendor/discord.sh --webhook-url="$DISCORD_WEBHOOK" --text "${text}" --username "${username}"
  fi
}
