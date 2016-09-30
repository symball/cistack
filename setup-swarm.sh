#!/usr/bin/env bash

# Be sure to have run the following commands prior to this script and
# generated a swarm token
#
echo "###############################"
echo "# Creating base swarm machine #"
echo "This is the 'base' server"
docker-machine create -d virtualbox local
eval "$(docker-machine env local)"
docker run swarm create

echo "######################"
echo "# Creating Key Store #"
echo "Needed as docker-compose not yet fully supporting native mode when using overlay"
docker-machine create \
    -d virtualbox \
    swarm-keystore
eval "$(docker-machine env swarm-keystore)"
docker run -d \
    -p "8500:8500" \
    -h "consul" \
    progrium/consul -server -bootstrap

echo "##########################"
echo "# Creating Swarm Manager #"
docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-master \
    --swarm-discovery="consul://$(docker-machine ip swarm-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip swarm-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-manager

echo "##########################"
echo "# Creating Swarm Node 00 #"
docker-machine create \
    -d virtualbox \
    --swarm \
    --swarm-discovery="consul://$(docker-machine ip swarm-keystore):8500" \
    --engine-opt="cluster-store=consul://$(docker-machine ip swarm-keystore):8500" \
    --engine-opt="cluster-advertise=eth1:2376" \
    swarm-node-00

# echo "##########################"
# echo "# Creating Swarm Node 01 #"
# docker-machine create \
#     -d virtualbox \
#     --swarm \
#     --swarm-discovery="consul://$(docker-machine ip swarm-keystore):8500" \
#     --engine-opt="cluster-store=consul://$(docker-machine ip swarm-keystore):8500" \
#     --engine-opt="cluster-advertise=eth1:2376" \
#     swarm-node-01

echo "#######"
echo "# END #"
echo 'To start using the swarm-manager, switch to its environment using: eval "$(docker-machine env --swarm swarm-manager)"'
