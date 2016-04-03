#!/usr/bin/env bash

die () {
  echo "$@" >&2
  exit 1;
}

# assign a network name
network="pubsub"

# check if custom network already exists, if yes, throw error
! docker network ls | egrep "$network" > /dev/null || die "Custom network '$network' already exists. Please remove it first and run script again."

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# create custom network
echo "Creating '$network' network"
docker network create -d bridge --subnet 172.14.0.0/24 $network 1> /dev/null

# start ELK stack
if ! bash start-elk.sh $network; then
  echo "Failed to start logging framework (ELK stack)."
fi

# set # of instances
num_of_publishers=1
num_of_subscribers=1
while [ "${1+defined}" ]; do
  if [ "${1:0:9}" = "publisher" ]; then
    num_of_publishers=${1:10}
  elif [ "${1:0:10}" = "subscriber" ]; then
    num_of_subscribers=${1:11}
  fi
  shift 1
done

# start microservice ecosystem
docker-compose -f $curr_dir/docker-compose.yml up -d
docker-compose -f $curr_dir/subscriber/docker-compose.yml up -d
docker-compose -f $curr_dir/publisher/docker-compose.yml up -d

# scale publishers and subscribers
if [ "$num_of_publishers" -gt "1" ]; then
  docker-compose -f $curr_dir/publisher/docker-compose.yml \
  scale app=$num_of_publishers
fi

if [ "$num_of_subscribers" -gt "1" ]; then
  docker-compose -f $curr_dir/subscriber/docker-compose.yml \
  scale app=$num_of_subscribers
fi
