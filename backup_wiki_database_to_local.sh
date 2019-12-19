#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/config/backup_config
source $SCRIPT_DIR/config/mysql_config
source $SCRIPT_DIR/config/wiki_config

source $SCRIPT_DIR/lib/date_utils.sh

backup_wiki_database_to_local()
{
  local current_date=$(get_current_date_as_YYYY_mm_dd)
  local backup_dir=$BACKUPS_DIR/$current_date
  local destination=$backup_dir/mediawiki-database-$current_date.sql

  mkdir -p $backup_dir

  printf "Creating mediawiki database dump file...\n"
  mysqldump -v -u $MYSQL_MEDIAWIKI_USERNAME --password=$MYSQL_MEDIAWIKI_PASSWORD -h $MYSQL_HOSTNAME mediawiki > $destination
  printf "Mediawiki database dump file created: $destination\n"
}

backup_wiki_database_to_local
