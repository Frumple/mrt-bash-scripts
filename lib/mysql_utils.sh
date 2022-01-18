#!/bin/bash

dump_mysql_database()
{
  local database_name=$1
  local config_file=$2
  local output_file=$3

  local output_directory=$(dirname ${output_file})
  mkdir -p ${output_directory}

  mysqldump --defaults-extra-file=${config_file} ${database_name} > ${output_file}
}
