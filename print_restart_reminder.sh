#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/lib/minecraft_server_control.sh

print_restart_reminder()
{
  tellraw_in_minecraft "[Server] ----------- ATTENTION! -----------" "yellow" "bold,italic"

  local number_of_minutes=$1
  if [ $number_of_minutes -eq 1 ]; then
    tellraw_in_minecraft "[Server] The server will restart in $number_of_minutes minute!" "yellow" "bold,italic"
  else
    tellraw_in_minecraft "[Server] The server will restart in $number_of_minutes minutes!" "yellow" "bold,italic"
  fi

  tellraw_in_minecraft "[Server] ---------------------------------" "yellow" "bold,italic"
}

print_restart_reminder $1
