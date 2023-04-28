#!/bin/bash
source ${SCRIPT_DIR}/config/base_config

get_last_matching_line()
{
  local regex=$1
  local log_file_path=$2
  local search_number_of_lines=$3

  if [[ -z $3 ]]; then
    search_number_of_lines=100
  fi

  tail -n ${search_number_of_lines} ${log_file_path} | grep -P "${regex}" | tail -n 1
}

get_number_of_matching_lines()
{
  local regex=$1
  local log_file_path=$2
  local search_number_of_lines=$3

  if [[ -z $3 ]]; then
    search_number_of_lines=100
  fi

  tail -n ${search_number_of_lines} ${log_file_path} | grep -c -P "${regex}"
}
