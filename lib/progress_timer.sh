#!/bin/bash
source $SCRIPT_DIR/lib/discord_utils.sh
source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/time_utils.sh

timer_text()
{
  if [[ -z $tellraw_color ]] && [[ -z $tellraw_options ]]; then
    say_in_minecraft "$1"
  else
    tellraw_in_minecraft "$1" "$tellraw_color" "$tellraw_options"
  fi

  if [[ ! -z $send_to_discord ]]; then
    send_message_to_discord "$1" "$discord_username"
  fi
}

run_progress_timer()
{
  OPTIND=1

  local task_function=$1
  shift

  local start_message="Starting $task_function..."
  local progress_message="$task_function in progress"
  local finish_message="$task_function complete"

  local message_interval_in_seconds=1
  local show_hours=false

  while getopts "s:p:f:m:h:c:o:d:u:" OPTION
  do
    case $OPTION in
      s) start_message="$OPTARG"
         ;;
      p) progress_message="$OPTARG"
         ;;
      f) finish_message="$OPTARG"
         ;;
      m) message_interval_in_seconds=$OPTARG
         ;;
      h) show_hours=$OPTARG
         ;;
      c) tellraw_color="$OPTARG"
         ;;
      o) tellraw_options="$OPTARG"
         ;;
      d) send_to_discord=$OPTARG
         ;;
      u) discord_username="$OPTARG"
         ;;
      ?) printf "Usage: %s <task_function> [-s <start_message>] [-p <progress_message>] [-f <finish_message>] [-m <message_interval>] [-h <show_hours>] [-c <tellraw_color>] [-o <tellraw_options>] [-d <send_to_discord>] [-u <discord_username>]" $(basename $0) >&2
         exit 2
         ;;
    esac
  done
  shift $(($OPTIND - 1))

  local start_time=$(get_current_unix_time)
  local elapsed_time=$start_time
  local formatted_time=""

  timer_text "$start_message"

  $task_function &
  background_pid=$!

  trap "kill $background_pid 2> /dev/null" EXIT

  while kill -0 $background_pid 2> /dev/null
  do
    sleep 1
    elapsed_time=$(get_elapsed_unix_time $start_time)

    modulus=$(($elapsed_time % $message_interval_in_seconds))
    if [ "$modulus" -eq 0 ]; then
      formatted_time=$(unix_time_to_minutes_seconds $elapsed_time $show_hours)
      timer_text "$progress_message: $formatted_time"
    fi
  done

  formatted_time=$(unix_time_to_minutes_seconds $elapsed_time $show_hours)
  timer_text "$finish_message: $formatted_time"
}
