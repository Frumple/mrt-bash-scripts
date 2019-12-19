#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )
source $SCRIPT_DIR/lib/minecraft_server_control.sh

test()
{
  run_minecraft_command "log hello world"
}

test
