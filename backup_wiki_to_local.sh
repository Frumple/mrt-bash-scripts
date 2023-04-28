#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/backup_config
source ${SCRIPT_DIR}/config/wiki_config

source ${SCRIPT_DIR}/lib/date_utils.sh

backup_wiki_files_to_local()
{
  local current_date=$(get_current_date_as_YYYY_mm_dd)

  local backup_dir=${BACKUPS_DIR}/${current_date}

  local source=${MEDIAWIKI_DIR}
  local destination=${backup_dir}/mediawiki-files-${current_date}.zip

  mkdir -p ${backup_dir}

  printf "Creating mediawiki zip file...\n"
  zip -r -9 ${destination} ${source}
  printf "Mediawiki zip file created: ${destination}\n"
}

backup_wiki_files_to_local
