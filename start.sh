#!/usr/bin/env bash

die () {
  echo "$@" >&2
  exit 1;
}

# check if custom network already exists, if yes, throw error
! docker network ls | egrep "pubsub" > /dev/null || die "Custom network 'pubsub' already exists. Please remove it first and run script again."

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

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# create custom network
echo "Creating 'pubsub' network"
docker network create -d bridge --subnet 172.14.0.0/24 pubsub

# start components
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
