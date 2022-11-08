#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh

restart_server()
{
  stop_minecraft_server
  wait_for_minecraft_server_to_stop
  move_uploaded_maps_to_minecraft_server
  start_minecraft_server
}

move_uploaded_maps_to_minecraft_server()
{
  mv ${MAP_UPLOAD_SOURCE}/*.dat ${MAP_UPLOAD_DESTINATION}
}

restart_server
