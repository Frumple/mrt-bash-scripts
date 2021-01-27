#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/dynmap_config
source ${SCRIPT_DIR}/config/log_config
source ${SCRIPT_DIR}/data/dynmap_tiles

source ${SCRIPT_DIR}/lib/minecraft_server_control.sh
source ${SCRIPT_DIR}/lib/dynmap_utils.sh
source ${SCRIPT_DIR}/lib/log_utils.sh

# How many lines back should we search for the dynmap render progress message in the Minecraft server log?
DYNMAP_SEARCH_NUMBER_OF_LINES=100

# Regex to search for dynmap progress message in server.log
DYNMAP_PROGRESS_LINE_REGEX="\[Dynmap Render Thread/INFO\]:( \[dynmap\])? Full render of"

# Regex to get the map name from the progress message
DYNMAP_MAP_NAME_REGEX="(?<=map ').+(?=' of)"

# Regex to get the world name from the progress message
DYNMAP_WORLD_NAME_REGEX="(?<=of ').+(?=' )"

# Regex to get the number of tiles rendered from the progress message
DYNMAP_TILES_RENDERED_REGEX="[0-9]+(?= tiles rendered)"

get_dynmap_progress_line()
{
  get_last_matching_line "${DYNMAP_PROGRESS_LINE_REGEX}" "${LATEST_LOG_PATH}" ${DYNMAP_SEARCH_NUMBER_OF_LINES}
}

is_dynmap_render_finished()
{
  local progress_line="$1"
  local dynmap_render="$2"
  local world_name=$(echo "${dynmap_render}" | cut -d \- -f 1)
  local match="Full render of '${world_name}' finished."

  if [[ ! -z `echo "${progress_line}" | grep "${match}"` ]]; then
    true
  else
    false
  fi
}

get_dynmap_map_name()
{
  local progress_line="$1"
  echo "${progress_line}" | grep -P -o "${DYNMAP_MAP_NAME_REGEX}"
}

get_dynmap_world_name()
{
  local progress_line="$1"
  echo "${progress_line}" | grep -P -o "${DYNMAP_WORLD_NAME_REGEX}"
}

get_dynmap_tiles_rendered()
{
  local progress_line="$1"
  echo "${progress_line}" | grep -P -o "${DYNMAP_TILES_RENDERED_REGEX}"
}

get_dynmap_tiles_total()
{
  local world="$1"
  local map="$2"

  echo ${DYNMAP_TILES["${world}-${map}"]}
}

print_dynmap_progress()
{
  # Sleep one second to avoid getting messages overlapped by other scripts such as the world save
  sleep 1

  local dynmap_render="$(cat ${DYNMAP_RENDER_FILE_PATH})"

  if [[ ! -z "${dynmap_render}" ]]; then
    local progress_line=$(get_dynmap_progress_line)

    if [[ ! -z "${progress_line}" ]]; then

      if is_dynmap_render_finished "${progress_line}" "${dynmap_render}"; then
        tellraw_in_minecraft "[Server] Dynmap render complete!" "aqua" "italic"
        echo "" > ${DYNMAP_RENDER_FILE_PATH}
      else
        local map_name=$(get_dynmap_map_name "${progress_line}")
        local world_name=$(get_dynmap_world_name "${progress_line}")
        local tiles_rendered=$(get_dynmap_tiles_rendered "${progress_line}")
        local tiles_total=$(get_dynmap_tiles_total "${world_name}" "${map_name}")

        local percent_complete=$(bc <<< "${tiles_rendered} * 100 / ${tiles_total}")
        local percent_decimal=$(bc <<< "${tiles_rendered} * 1000 / ${tiles_total} % 10")

        local pretty_map_name=$(get_pretty_map_name "${map_name}")
        local pretty_world_name=$(get_pretty_world_name "${world_name}")

        tellraw_in_minecraft "[Server] Dynmap render in progress..." "aqua" "italic"
        tellraw_in_minecraft "[Server] ${pretty_map_name} Map on ${pretty_world_name} World is ${percent_complete}.${percent_decimal}% complete." "aqua" "italic"
      fi
    fi
  fi
}

print_dynmap_progress
