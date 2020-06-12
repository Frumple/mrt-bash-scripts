#!/bin/bash
source $SCRIPT_DIR/config/discord_config

send_message_to_discord() {
  if [[ -z $2 ]]; then
    $SCRIPT_DIR/lib/vendor/discord.sh --webhook-url="$DISCORD_WEBHOOK" --text "$1"
  else
    $SCRIPT_DIR/lib/vendor/discord.sh --webhook-url="$DISCORD_WEBHOOK" --text "$1" --username "$2"
  fi
}
