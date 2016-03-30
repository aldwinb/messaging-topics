#!/usr/bin/env bash

# die () {
#   echo >&2 "$@"
#   exit 1
# }

# validate options
# [ "$#" -eq "1" ] || die "Invalid argument(s). USAGE:"\
#  "start.sh"

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# start components
docker-compose -f $curr_dir/docker-compose.yml up -d
docker-compose -f $curr_dir/subscriber/docker-compose.yml up -d
docker-compose -f $curr_dir/publisher/docker-compose.yml up -d

