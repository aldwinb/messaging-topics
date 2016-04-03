#!/usr/bin/env bash

# assign a network name
network=$1

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# destroy logspout
docker-compose -f $curr_dir/docker-compose-logspout.yml stop
# destroy logstash
docker-compose -f $curr_dir/docker-compose-logstash.yml stop
# destroy logstash
docker-compose -f $curr_dir/docker-compose-elasticsearch.yml stop
