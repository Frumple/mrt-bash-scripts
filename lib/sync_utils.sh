#!/bin/bash

is_world_save_running()
{
  [[ `ps acx | grep --count "rdiff-backup"` -gt 0 ]]
}

is_offsite_backup_running()
{
  [[ `ps acx | grep --count "restic"` -gt 0 ]]
}
