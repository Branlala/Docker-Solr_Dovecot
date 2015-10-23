#!/bin/bash
######################################################################################
##### Script adapted from https://gist.github.com/andreyserdjuk/bd92b5beba2719054dfe
##### By MrRaph_ 
#####################################################################################


# in case of conflict with local nginx:
# make sure in all *.confs (
#   also in default and example to avoid error like
#     'nginx: [emerg] bind() to 0.0.0.0:80 failed (98: Address already in use)'
# )
# set for instance "listen 127.0.0.1:80" instead of "listen *:80"

# docker & network settings
DOCKER_IMAGE_NAME="cozy/full"                 # build of nginx-php - for example
DOCKER_CONTAINERS_NAME="cozy_bridged"                  # our container's name
DOCKER_NETWORK_INTERFACE_NAME="em1:1"                  # default we have eth0 (or p2p1), so interface will eth0:1 or p2p1:1
DOCKER_NETWORK_INTERFACE_IP="10.0.0.1"                  # network interface address

# try to find created this network interface
found_iface=$(ifconfig | grep "$DOCKER_NETWORK_INTERFACE_NAME")
if [ -z "$found_iface" ]; then
  # create & start some another network interface for docker container
  sudo ifconfig $DOCKER_NETWORK_INTERFACE_NAME $DOCKER_NETWORK_INTERFACE_IP netmask 255.255.255.0 up
else
  echo "$DOCKER_NETWORK_INTERFACE_NAME with ip $DOCKER_NETWORK_INTERFACE_IP alredy exists";
fi

# start conteiner if "docker some_image run" earlier
found_container=$(docker ps -a | grep "$DOCKER_CONTAINERS_NAME")
if [ ! -z "$found_container" ]; then
  sudo docker start "$DOCKER_CONTAINERS_NAME"
else
  # bind docker container to created network interface
  sudo docker run -d --name="$DOCKER_CONTAINERS_NAME" -p $DOCKER_NETWORK_INTERFACE_IP:8880:80/tcp $DOCKER_IMAGE_NAME
fi

# also you can manually remove created virtual network interface
# ifconfig $DOCKER_NETWORK_INTERFACE_NAME down

