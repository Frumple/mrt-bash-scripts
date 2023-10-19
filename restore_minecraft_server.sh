#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/sync_config

restore_minecraft_server()
{
  local restore_time="now"

  if [ ! -z "$1" ]; then
    restore_time=$1
  fi

  if ${SYNC_ENABLED}; then
    printf "This script will not run while syncing is enabled. Exiting...\n"
    exit
  fi

  mkdir -p ${SYNC_SOURCE}
  rdiff-backup -v ${SYNC_VERBOSITY} restore --at ${restore_time} ${SYNC_DESTINATION} ${SYNC_SOURCE}
}

restore_minecraft_server $1
