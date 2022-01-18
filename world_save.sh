#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/print_tps_counter.sh
source ${SCRIPT_DIR}/sync_minecraft_server.sh

# Combines printing the TPS and syncing the minecraft server
# Intended to run every 15 minutes

world_save()
{
  print_tps_counter 15
  sleep 3
  sync_minecraft_server
}

world_save
