#!/bin/bash
source $SCRIPT_DIR/config/base_config

run_minecraft_command()
{
  docker exec $CONTAINER_NAME ./run-minecraft-command.sh "$1"
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

  if [[ $options == *"bold"* ]]; then
    bold_option=", \"bold\":true"
  fi

  if [[ $options == *"italic"* ]]; then
    italic_option=", \"italic\":true"
  fi

  if [[ $options == *"underlined"* ]]; then
    underlined_option=", \"underlined\":true"
  fi

  local json="{\"text\":\"$text\", \"color\":\"$color\"$bold_option$italic_option$underlined_option}"

  run_minecraft_command "tellraw @a $json"

  # /tellraw doesn't get recorded in the server logs, use an Essentials /customtext command called /log to print the text content into the logs
  run_minecraft_command "log $text"
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

  if $flush; then
    command+=" flush"
  fi

  run_minecraft_command "$command"
  sync
  sleep $MINECRAFT_SAVE_ALL_DELAY_IN_SECONDS
}

restart_minecraft_server()
{
  run_minecraft_command "restart"
}
