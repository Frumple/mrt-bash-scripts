#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/config/ftp_config
source $SCRIPT_DIR/config/sync_config

source $SCRIPT_DIR/lib/minecraft_server_control.sh
source $SCRIPT_DIR/lib/progress_timer.sh
source $SCRIPT_DIR/lib/sync_utils.sh

backup_minecraft_to_ftp()
{
  if is_duplicity_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run offsite backup." "dark_red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: Another offsite backup is in progress." "dark_red" "bold,italic"
    printf "duplicity is currently running. Aborting...\n"
    exit 1
  fi

  if is_rdiff_backup_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run offsite backup." "dark_red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: World save is in progress." "dark_red" "bold,italic"
    printf "rdiff-backup is currently running. Aborting...\n"
    exit 1
  fi

  export FTP_PASSWORD=$FTP_BACKUP_PASSWORD

  run_progress_timer "cleanup_old_ftp_backups" \
    "-s" "[Server] Cleaning up old offsite backups..." \
    "-p" "[Server] Offsite backup cleanup in progress" \
    "-f" "[Server] Offsite backup cleanup complete" \
    "-m" "60" \
    "-c" "light_purple" \
    "-o" "bold,italic"

  run_progress_timer "run_ftp_backup" \
    "-s" "[Server] Starting offsite backup..." \
    "-p" "[Server] Offsite backup in progress" \
    "-f" "[Server] Offsite backup complete" \
    "-m" "60" \
    "-h" "true" \
    "-c" "light_purple" \
    "-o" "bold,italic"

  unset FTP_PASSWORD
}

run_ftp_backup()
{
  duplicity \
    $FTP_BACKUP_COMMON_OPTIONS \
    --full-if-older-than $FTP_BACKUP_FULL_BACKUP_EVERY \
    $FTP_BACKUP_SOURCE \
    $FTP_BACKUP_TARGET
}

cleanup_old_ftp_backups()
{
  lftp \
    -e "set ssl-allow false; rm -rf servers/$SERVER_NAME; mkdir servers/$SERVER_NAME; exit" \
    -u $FTP_BACKUP_USERNAME,$FTP_BACKUP_PASSWORD \
    $FTP_BACKUP_SERVER
}

backup_minecraft_to_ftp
