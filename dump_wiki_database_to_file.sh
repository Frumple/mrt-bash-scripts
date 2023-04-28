#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/config/wiki_config
source ${SCRIPT_DIR}/lib/mysql_utils.sh

dump_wiki_database_to_file()
{
  local mysql_database=mediawiki
  local output_file="${MEDIAWIKI_DATABASE_DIR}/${mysql_database}.sql"

  dump_mysql_database "${mysql_database}" "${MYSQL_MEDIAWIKI_CONFIG_FILE}" "${output_file}"

  printf "MediaWiki database written to: ${output_file}\n"
}

# Only run this script if it is run directly
running_script=$( basename ${0#~} )
this_script=$( basename ${BASH_SOURCE} )

if [[ ${running_script} = ${this_script} ]]; then
  dump_wiki_database_to_file
fi
