#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/b2_minecraft_config
source ${SCRIPT_DIR}/config/sync_config

source ${SCRIPT_DIR}/lib/minecraft_server_control.sh
source ${SCRIPT_DIR}/lib/progress_timer.sh
source ${SCRIPT_DIR}/lib/sync_utils.sh

backup_minecraft_to_b2()
{
  if is_world_save_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run offsite backup." "dark_red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: World save is in progress." "dark_red" "bold,italic"
    exit 1
  fi

  if is_offsite_backup_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run offsite backup." "dark_red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: Another offsite backup is in progress." "dark_red" "bold,italic"
    exit 1
  fi

  export B2_ACCOUNT_ID
  export B2_ACCOUNT_KEY
  export RESTIC_REPOSITORY
  export RESTIC_PASSWORD

  run_progress_timer "cleanup_old_b2_backups" \
    "-s" "[Server] Cleaning up old offsite backups..." \
    "-p" "[Server] Offsite backup cleanup in progress" \
    "-f" "[Server] Offsite backup cleanup complete" \
    "-m" "60" \
    "-c" "light_purple" \
    "-o" "bold,italic" \
    "-d" "true" \
    "-u" "Offsite Backup"

  run_progress_timer "run_b2_backup" \
    "-s" "[Server] Starting offsite backup..." \
    "-p" "[Server] Offsite backup in progress" \
    "-f" "[Server] Offsite backup complete" \
    "-m" "60" \
    "-h" "true" \
    "-c" "light_purple" \
    "-o" "bold,italic" \
    "-d" "true" \
    "-u" "Offsite Backup"

  unset B2_ACCOUNT_ID
  unset B2_ACCOUNT_KEY
  unset RESTIC_REPOSITORY
  unset RESTIC_PASSWORD
}

cleanup_old_b2_backups()
{
  restic forget ${B2_FORGET_OPTIONS}
}

run_b2_backup()
{
  restic backup ${B2_BACKUP_OPTIONS} ${B2_SOURCE}
}

backup_minecraft_to_b2
