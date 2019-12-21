#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/config/log_config

source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/log_utils.sh

# Path to file storing the last TPS value
TPS_LAST_VALUE_FILE_PATH=$SCRIPT_DIR/data/last_tps

# Should the script run the /tps command?
# This may be set to false if the server wrapper (i.e. AMP) periodically runs the /tps command already.
TPS_RUN_COMMAND=false

# Number of seconds to wait between sending the /tps command and searching its output
# Set this to 0 if TPS_RUN_COMMAND is false
TPS_DELAY_IN_SECONDS=0

# How many lines back should we search for the /tps output in the Minecraft server log?
TPS_SEARCH_NUMBER_OF_LINES=100

# Regex to search for the /tps output
TPS_OUTPUT_LINE_REGEX="\[Server thread/INFO\]: TPS from last 1m, 5m, 15m:"

# Regex to get the latest TPS value
TPS_VALUE_REGEX="[0-9]+\.[0-9]+\*?"

# Minimum threshold for good TPS
TPS_GOOD_THRESHOLD=18

# Minimum threshold for ok TPS
TPS_OK_THRESHOLD=15

get_tps_line()
{
  get_last_matching_line "$TPS_OUTPUT_LINE_REGEX" "$LATEST_LOG_PATH" $TPS_SEARCH_NUMBER_OF_LINES
}

get_tps_value()
{
  # tps_range can be of values 1, 5, or 15,
  # indicating whether to get the TPS value for the last 1, 5, or 15 minutes
  local tps_range=$1
  local tps_index=1

  if [[ "$tps_range" -eq 5 ]]; then
    tps_index=2
  elif [[ "$tps_range" -eq 15 ]]; then
    tps_index=3
  fi
  get_tps_line | grep -E -o "$TPS_VALUE_REGEX" | head -$tps_index | tail -1
}

print_tps_counter()
{
  echo $LATEST_LOG_PATH

  local tps_range=$1
  if [[ -z "$tps_range" ]]; then
    tps_range=1
  fi

  if $TPS_RUN_COMMAND; then
    run_minecraft_command "tps"
  fi

  sleep $TPS_DELAY_IN_SECONDS
  local current_tps_value="$(get_tps_value $tps_range)"
  local last_tps_value="$(cat $TPS_LAST_VALUE_FILE_PATH)"

  local color="white"
  local change="(?)"

  if [[ -z "$current_tps_value" ]] || [[ "$current_tps_value" == *\* ]]; then
    current_tps_value="N/A"
    color="red"
  else
    if [[ $(echo "$current_tps_value >= $TPS_GOOD_THRESHOLD" | bc -l) -eq 1 ]]; then
      color="green"
    elif [[ $(echo "$current_tps_value >= $TPS_OK_THRESHOLD" | bc -l) -eq 1 ]]; then
      color="yellow"
    else
      color="red"
    fi

    if [[ $(echo "$current_tps_value > $last_tps_value" | bc -l) -eq 1 ]]; then
      change="(+)"
    elif [[ $(echo "$current_tps_value < $last_tps_value" | bc -l) -eq 1 ]]; then
      change="(-)"
    else
      change="(=)"
    fi
  fi

  echo $current_tps_value > $TPS_LAST_VALUE_FILE_PATH

  tellraw_in_minecraft "[Server] Average TPS in last 15 min: $current_tps_value $change" "$color" "bold,italic"
}

print_tps_counter $1
