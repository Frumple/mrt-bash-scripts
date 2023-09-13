#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/print_tps_counter.sh
source ${SCRIPT_DIR}/sync_minecraft_server.sh

# Combines printing the TPS and syncing the minecraft server
# Intended to run every 15 minutes

world_save()
{
  local flush_chunks=$1

  print_tps_counter
  sleep 3
  sync_minecraft_server ${flush_chunks}
}

world_save $1
