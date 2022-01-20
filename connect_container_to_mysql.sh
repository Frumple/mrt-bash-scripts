#!/bin/bash
export SCRIPT_DIR=$( cd "$( dirname "$0" )" && pwd )

# When a Minecraft server container is started using Pterodactyl, it is only connected to one external Docker network.
# We also need to connect the container to the "mysql-net" internal Docker network, so that the server's plugins can connect to MySQL.

# This could be done by granting Docker command privileges to the container, but that is a security risk.
# Instead, this is achieved using named pipes:

# 1. The container's startup script (entrypoint.sh) sends the container ID to the named pipe.
# 2. This script continuously reads the named pipe.
#    Upon receiving a container ID, it runs the "docker network connect" command to connect the container to "mysql-net".

# Directory where all named pipes reside
PIPE_DIR=/home/frumple/scripts/pipes

# Name of the named pipe
PIPE_NAME=connect_container_to_mysql

# Full path to the named pipe
PIPE_PATH="${PIPE_DIR}/${PIPE_NAME}"

# Name of the docker network to connect the container to
DOCKER_MYSQL_NETWORK_NAME=mysql-net

connect_container_to_mysql()
{
  if [[ -p ${PIPE_PATH} ]]; then
    printf "Named pipe already exists: ${PIPE_PATH}\n"
  else
    printf "Creating named pipe: ${PIPE_PATH}\n"
    mkdir ${PIPE_DIR}
    mkfifo ${PIPE_PATH}
  fi

  printf "Now listening for container IDs from named pipe...\n"

  while
    local container_id=$(cat ${PIPE_PATH})
    printf "Running: docker network connect ${DOCKER_MYSQL_NETWORK_NAME} ${container_id}\n"
    docker network connect ${DOCKER_MYSQL_NETWORK_NAME} ${container_id}
    [[ ! -z ${container_id} ]]
  do true; done

  printf "Unable to read pipe, exiting...\n"
}

connect_container_to_mysql
