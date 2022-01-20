#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source ${SCRIPT_DIR}/lib/minecraft_server_control.sh

restart_server()
{
  restart_minecraft_server
}

restart_server
