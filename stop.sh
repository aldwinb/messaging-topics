#!/usr/bin/env bash


# assign a network name
network="pubsub"

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# destroy components
docker-compose -f $curr_dir/docker-compose.yml stop

bash stop-elk.sh

# destroy custom network
echo "Destroying '$network' network"
! docker network ls | egrep "$network" > /dev/null  || docker network rm $network
