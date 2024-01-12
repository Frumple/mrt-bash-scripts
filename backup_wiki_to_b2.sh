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

  export AWS_ACCESS_KEY_ID
  export AWS_SECRET_ACCESS_KEY
  export RESTIC_REPOSITORY
  export RESTIC_PASSWORD
  export GOMAXPROCS

  cleanup_old_b2_backups
  run_b2_backup

  unset AWS_ACCESS_KEY_ID
  unset AWS_SECRET_ACCESS_KEY
  unset RESTIC_REPOSITORY
  unset RESTIC_PASSWORD
  unset GOMAXPROCS

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
  restic forget ${RESTIC_FORGET_OPTIONS}
}

run_b2_backup()
{
  restic backup ${RESTIC_BACKUP_OPTIONS} ${RESTIC_SOURCE}
}

backup_wiki_to_b2
