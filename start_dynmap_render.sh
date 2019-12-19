#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/config/dynmap_config

source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/dynmap_utils.sh

start_dynmap_render()
{
  local world_name=$1
  local map_name=$2

  if [[ ! -z $world_name ]]; then
    local pretty_world_name=$(get_pretty_world_name "$world_name")

    tellraw_in_minecraft "[Server] Starting dynmap render..." "aqua" "italic"

    if [[ -z $map_name ]]; then
      tellraw_in_minecraft "[Server] Rendering Flat and 3D Maps on $pretty_world_name World..." "aqua" "italic"
      run_minecraft_command "dynmap fullrender $world_name"
      echo "$world_name" > $DYNMAP_RENDER_FILE_PATH
    else
      local pretty_map_name=$(get_pretty_map_name "$map_name")

      tellraw_in_minecraft "[Server] Rendering $pretty_map_name Map on $pretty_world_name World..." "aqua" "italic"
      run_minecraft_command "dynmap fullrender $world_name:$map_name"
      echo "$world_name-$map_name" > $DYNMAP_RENDER_FILE_PATH
    fi

    tellraw_in_minecraft "[Server] Expect lag for at least the next hour." "aqua" "italic"
  else
    echo "World name must be specified."
  fi
}

start_dynmap_render $1 $2
