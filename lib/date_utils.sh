#!/bin/bash

get_current_date_as_YYYY_mm_dd() {
  local current_date=`date +"%Y-%m-%d"`
  printf "%s" ${current_date}
}
