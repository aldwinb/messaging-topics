#!/usr/bin/env bash

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
