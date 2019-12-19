#!/bin/bash

dump_mysql_database()
{
  local database_name=$1
  local mysql_hostname=$2
  local mysql_username=$3
  local mysql_password=$4
  local output_file=$5

  local output_directory=$(dirname $output_file)
  mkdir -p $output_directory

  mysqldump --single-transaction --quick --host=$mysql_hostname --user=$mysql_username --password=$mysql_password $database_name > $output_file
}
