#!/bin/bash

replace_line_in_file()
{
  local regex=$1
  local new_text=$2
  local file_path=$3

  sed -i "s/${regex}/${new_text}/" "${file_path}"
}
