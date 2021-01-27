#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/dynmap_config
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh

cancel_dynmap_render()
{
  local world_name=$1

  if [[ ! -z ${world_name} ]]; then
    echo "" > ${DYNMAP_RENDER_FILE_PATH}
    run_minecraft_command "dynmap cancelrender ${world_name}"
    tellraw_in_minecraft "[Server] Dynmap render cancelled." "aqua" "italic"
  else
    echo "World name must be specified."
  fi
}

cancel_dynmap_render $1
