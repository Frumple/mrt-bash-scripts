#!/bin/bash

is_rdiff_backup_running()
{
  if [[ `ps acx | grep -v "grep" | grep --count "rdiff-backup"` -gt 0 ]]; then
    true
  else
    false
  fi
}

is_lftp_running()
{
  if [[ `ps acx | grep -v "grep" | grep --count "lftp"` -gt 0 ]]; then
    true
  else
    false
  fi
}
