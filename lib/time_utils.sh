#!/bin/bash

get_elapsed_unix_time() {
  local start_unix_time=$1
  local current_unix_time=$(get_current_unix_time)
  if [ -z "${start_unix_time}" ]; then
    start_unix_time=${current_unix_time}
  fi
  local elapsed_unix_time=$((current_unix_time - start_unix_time))
  printf ${elapsed_unix_time}
}

get_current_unix_time() {
  printf $(date '+%s')
}

unix_time_to_minutes_seconds() {
  local unix_time=$1
  local show_hours=$2

  local unix_minutes=$(((${unix_time} / 60) % 60))
  local unix_seconds=$((${unix_time} % 60))

  if ${show_hours}; then
    local unix_hours=$((${unix_time} / 3600))
    printf "%dh %dm %ds" ${unix_hours} ${unix_minutes} ${unix_seconds}
  else
    printf "%dm %ds" ${unix_minutes} ${unix_seconds}
  fi
}
