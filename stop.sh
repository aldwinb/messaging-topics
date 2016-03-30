#!/usr/bin/env bash

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# destroy components
docker-compose -f $curr_dir/publisher/docker-compose.yml stop
docker-compose -f $curr_dir/subscriber/docker-compose.yml stop
docker-compose -f $curr_dir/docker-compose.yml stop
