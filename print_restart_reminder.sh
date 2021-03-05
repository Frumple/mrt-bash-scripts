#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh
source ${SCRIPT_DIR}/lib/discord_utils.sh

print_restart_reminder()
{
  local number_of_minutes=$1
  local minecraft_message=""
  local discord_message=""
  if [ ${number_of_minutes} -eq 1 ]; then
    minecraft_message="[Server] The server will restart in ${number_of_minutes} minute!"
    discord_message=":warning: **The server will restart in ${number_of_minutes} minute!** :warning:"
  else
    minecraft_message="[Server] The server will restart in ${number_of_minutes} minutes!"
    discord_message=":warning: **The server will restart in ${number_of_minutes} minutes!** :warning:"
  fi

  tellraw_in_minecraft "[Server] ----------- ATTENTION! -----------" "yellow" "bold,italic"
  tellraw_in_minecraft "${minecraft_message}" "yellow" "bold,italic"
  tellraw_in_minecraft "[Server] ---------------------------------" "yellow" "bold,italic"

  send_message_to_discord "${discord_message}" "Server Restart"
}

print_restart_reminder $1
