#!/bin/bash
source ${SCRIPT_DIR}/config/base_config
source ${SCRIPT_DIR}/config/log_config
source ${SCRIPT_DIR}/config/minecraft_config

source ${SCRIPT_DIR}/lib/log_utils.sh
source ${SCRIPT_DIR}/lib/pterodactyl_utils.sh

run_minecraft_command()
{
  send_command_to_pterodactyl_server ${PTERODACTYL_SERVER_ID} "$1"
}

say_in_minecraft()
{
  run_minecraft_command "say $1"
}

tellraw_in_minecraft()
{
  local text=$1
  local color=$2
  local options=$3

  local bold_option=
  local italic_option=
  local underline_option=

  if [[ ${options} == *"bold"* ]]; then
    bold_option=", \\\"bold\\\":true"
  fi

  if [[ ${options} == *"italic"* ]]; then
    italic_option=", \\\"italic\\\":true"
  fi

  if [[ ${options} == *"underlined"* ]]; then
    underlined_option=", \\\"underlined\\\":true"
  fi

  local json="{\\\"text\\\":\\\"${text}\\\", \\\"color\\\":\\\"${color}\\\"${bold_option}${italic_option}${underlined_option}}"

  run_minecraft_command "tellraw @a $json"

  # /tellraw doesn't get recorded in the server logs, use an Essentials /customtext command called /log to print the text content into the logs
  run_minecraft_command "log ${text}"
}

enter_readonly_mode_in_minecraft()
{
  run_minecraft_command "save-off"
}

exit_readonly_mode_in_minecraft()
{
  run_minecraft_command "save-on"
}

save_minecraft_world()
{
  local flush=$1
  local command="save-all"
  local save_all_time_in_seconds=1

  if ${flush}; then
    command+=" flush"
  fi

  run_minecraft_command "${command}"
  sleep 1

  while [ $(get_number_of_matching_lines "Saved the game" "${LATEST_LOG_PATH}" ${SAVE_ALL_SEARCH_NUMBER_OF_LINES}) -lt 1 ] && [ ${save_all_time_in_seconds} -lt ${SAVE_ALL_TIMEOUT_IN_SECONDS} ]
  do
    sleep 1
    ((save_all_time_in_seconds++))
  done
  sync
}

restart_minecraft_server()
{
  run_minecraft_command "restart"
}
