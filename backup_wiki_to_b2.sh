#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/b2_config
source ${SCRIPT_DIR}/config/wiki_config

source ${SCRIPT_DIR}/lib/wiki_utils.sh
source ${SCRIPT_DIR}/dump_wiki_database_to_file.sh

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

backup_wiki_to_b2()
{
  enter_wiki_readonly_mode

  dump_wiki_database_to_file

  exit_wiki_readonly_mode
}

backup_wiki_to_b2
