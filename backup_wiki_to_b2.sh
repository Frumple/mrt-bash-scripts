#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/b2_wiki_config
source ${SCRIPT_DIR}/config/wiki_config

source ${SCRIPT_DIR}/lib/wiki_utils.sh
source ${SCRIPT_DIR}/dump_wiki_database_to_file.sh

backup_wiki_to_b2()
{
  enter_wiki_readonly_mode
  dump_wiki_database_to_file

  export B2_ACCOUNT_ID
  export B2_ACCOUNT_KEY
  export RESTIC_REPOSITORY
  export RESTIC_PASSWORD

  cleanup_old_b2_backups
  run_b2_backup

  unset B2_ACCOUNT_ID
  unset B2_ACCOUNT_KEY
  unset RESTIC_REPOSITORY
  unset RESTIC_PASSWORD

  exit_wiki_readonly_mode
}

enter_wiki_readonly_mode()
{
  printf "${MEDIAWIKI_READONLY_MESSAGE}" >> "${MEDIAWIKI_READONLY_LOCK_FILE}"
  set_wiki_sitenotice "${MEDIAWIKI_READONLY_SITENOTICE}"
}

exit_wiki_readonly_mode()
{
  rm "${MEDIAWIKI_READONLY_LOCK_FILE}"
  set_wiki_sitenotice ""
}

cleanup_old_b2_backups()
{
  restic forget ${B2_FORGET_OPTIONS}
}

run_b2_backup()
{
  restic backup ${B2_BACKUP_OPTIONS} ${B2_SOURCE}
}

backup_wiki_to_b2
