#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/config/backup_config
source $SCRIPT_DIR/config/sync_config

source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/date_utils.sh
source $SCRIPT_DIR/lib/progress_timer.sh

run_zip_backup()
{
  local current_date=$(get_current_date_as_YYYY_mm_dd)

  local backup_dir=$BACKUPS_DIR/$current_date

  local source=$SYNC_DESTINATION
  local destination=$backup_dir/minecraft-$SERVER_NAME-$current_date.zip

  mkdir -p $backup_dir

  zip -r -9 $destination $source -x $source/rdiff-backup-data/**\*

  printf "Backup zip file created: $destination\n"
}

backup_minecraft_to_local()
{
  if $SYNC_ENABLED; then
    printf "This script will not run while syncing is enabled. It can be disabled in config/sync_config. Exiting...\n"
    exit 1
  fi

  run_progress_timer "run_zip_backup" \
    "-s" "[Server] Starting local backup..." \
    "-p" "[Server] Local backup in progress" \
    "-f" "[Server] Local backup complete" \
    "-m" "60" \
    "-h" "true" \
    "-c" "light_purple" \
    "-o" "bold,italic"
}

backup_minecraft_to_local
