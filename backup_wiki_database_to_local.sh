#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/backup_config
source ${SCRIPT_DIR}/config/wiki_config

source ${SCRIPT_DIR}/lib/date_utils.sh
source ${SCRIPT_DIR}/lib/mysql_utils.sh

backup_wiki_database_to_local()
{
  local current_date=$(get_current_date_as_YYYY_mm_dd)
  local mysql_database=mediawiki
  local backup_dir=${BACKUPS_DIR}/${current_date}
  local output_file=${backup_dir}/${mysql_database}-database-${current_date}.sql

  mkdir -p ${backup_dir}

  printf "Creating mediawiki database dump file...\n"
  dump_mysql_database ${mysql_database} "${MYSQL_MEDIAWIKI_CONFIG_FILE}" "${output_file}"
  printf "Mediawiki database dump file created: ${output_file}\n"
}

backup_wiki_database_to_local
