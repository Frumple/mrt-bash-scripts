#!/bin/bash

get_pretty_world_name()
{
  local world_name="$1"
  echo "${world_name^}"
}

get_pretty_map_name()
{
  local map_name="$1"
  if [[ $map_name == "surface" ]]; then
    echo "3D"
  else
    echo "Flat"
  fi
}
