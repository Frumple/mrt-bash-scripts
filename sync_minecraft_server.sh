#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/base_config
source ${SCRIPT_DIR}/config/discord_config
source ${SCRIPT_DIR}/config/minecraft_config
source ${SCRIPT_DIR}/config/sync_config

source ${SCRIPT_DIR}/lib/discord_utils.sh
source ${SCRIPT_DIR}/lib/mysql_utils.sh
source ${SCRIPT_DIR}/lib/sync_utils.sh
source ${SCRIPT_DIR}/lib/progress_timer.sh
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh

sync_minecraft_server()
{
  if is_world_save_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run world save." "red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: Another world save is in progress." "red" "bold,italic"
    exit 1
  fi

  if is_offsite_backup_running; then
    tellraw_in_minecraft "[Server] WARNING: Unable to run world save." "red" "bold,italic"
    tellraw_in_minecraft "[Server] Reason: Offsite backup is in progress." "red" "bold,italic"
    exit 1
  fi

  if ${SYNC_ENABLED}; then
    run_progress_timer "run_all_sync_tasks" \
      "-s" "[Server] Starting save, lag spike begins..." \
      "-p" "[Server] Save in progress" \
      "-f" "[Server] Save complete" \
      "-m" "30" \
      "-c" "light_purple" \
      "-o" "bold,italic"
  else
    tellraw_in_minecraft "[Server] WARNING: Scheduled world save has been disabled." "red" "bold,italic"
    send_message_to_discord "<@$DISCORD_OWNER_USER_ID> **Scheduled world save has been disabled.**" "World Save"
  fi
}

run_all_sync_tasks()
{
  dump_all_plugin_databases
  sync_minecraft_files
}

dump_all_plugin_databases()
{
  readarray plugin_databases < ${SCRIPT_DIR}/config/plugin_databases

  for database_name in "${plugin_databases[@]}"
  do
    dump_plugin_database ${database_name}
  done
}

dump_plugin_database()
{
  local database_name=$1
  local mysql_database=$(printf "%s_%s" ${database_name} ${SERVER_NAME})
  local output_file="${SYNC_SOURCE}/databases/$database_name.sql"

  printf "Dumping '${database_name}' database...\n"
  dump_mysql_database "${mysql_database}" "${MYSQL_MINECRAFT_CONFIG_FILE}" "${output_file}"
}

sync_minecraft_files()
{
  enter_readonly_mode_in_minecraft
  save_minecraft_world true

  tellraw_in_minecraft "[Server] Lag spike ends." "light_purple" "bold,italic"

  copy_diffs
  clean_old_diffs
  exit_readonly_mode_in_minecraft
}

copy_diffs()
{
  ${SYNC_NICE_PREAMBLE} rdiff-backup ${SYNC_BACKUP_ARGUMENTS} -v ${SYNC_VERBOSITY} ${SYNC_SOURCE} ${SYNC_DESTINATION}
}

clean_old_diffs()
{
  ${SYNC_NICE_PREAMBLE} rdiff-backup --remove-older-than ${SYNC_REMOVE_DIFFS_OLDER_THAN} --force -v ${SYNC_VERBOSITY} ${SYNC_DESTINATION}
}

# Only run this script if it is run directly
running_script=$( basename ${0#~} )
this_script=$( basename ${BASH_SOURCE} )

if [[ ${running_script} = ${this_script} ]]; then
  sync_minecraft_server
fi
