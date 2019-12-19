#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/log_utils.sh

print_temp_dynmap_reminder()
{
  sleep 5
  tellraw_in_minecraft "[Server] New World Dynmap Render in progress..." "aqua" "italic"
  tellraw_in_minecraft "[Server] No WorldEdits or other dynmap renders allowed." "aqua" "italic"
}

print_temp_dynmap_reminder $1
