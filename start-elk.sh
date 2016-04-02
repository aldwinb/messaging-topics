#!/usr/bin/env bash

exit_code=1

# get network name
network=$1

# get current directory
curr_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# start Elasticsearch container first to get it's IP, and then set it as
# env variable so that Logstash can pick it up
if docker-compose -f $curr_dir/docker-compose-elasticsearch.yml up -d; then
  export ELASTIC_IP=$(docker inspect --format '{{ .NetworkSettings.Networks.'$network'.IPAddress}}' elasticsearch-1)


  # Logstash needs to be online first before we can start logspout, or else
  # logspout will fail
  if docker-compose -f $curr_dir/docker-compose-logstash.yml up -d; then
    logstash_ip=$(docker inspect --format '{{ .NetworkSettings.Networks.'$network'.IPAddress}}' logstash-1)
    while ! nc -zu $logstash_ip 5000; do
      echo "Pinging logstash-1 in 1 sec..."
      sleep 1
    done

    # start logspout
    if docker-compose -f $curr_dir/docker-compose-logspout.yml up -d; then
      exit_code=0
    else
      # destroy logstash
      docker-compose -f $curr_dir/docker-compose-logstash.yml stop
    fi
  else
    # destroy logspout
    docker-compose -f $curr_dir/docker-compose-elasticsearch.yml stop
  fi
fi

exit $exit_code
