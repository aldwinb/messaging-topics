#!/usr/bin/env bash

die () {
  echo >&2 "$@"
  exit 1
}

# validate options
#[ "$#" -eq "1" ] || die "Invalid argument(s). USAGE:"\
#  "simulation.sh"

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# start components
docker-compose -f $curr_dir/docker-compose.yml up -d
docker-compose -f $curr_dir/subscriber/docker-compose.yml up -d
docker-compose -f $curr_dir/publisher/docker-compose.yml up -d

sleep 10

# destroy components
docker-compose -f $curr_dir/publisher/docker-compose.yml stop
docker-compose -f $curr_dir/subscriber/docker-compose.yml stop
docker-compose -f $curr_dir/docker-compose.yml stop
