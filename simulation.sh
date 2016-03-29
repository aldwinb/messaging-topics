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

exit_code=1

# start external components
if docker-compose -f $curr_dir/docker-compose.yml up -d; then

  # if start was successful, run apps
  echo "Starting subscriber..."
  docker-compose -f $curr_dir/subscriber/docker-compose.yml up -d
  echo "Starting publisher..."
  docker-compose -f $curr_dir/publisher/docker-compose.yml up -d

  #sleep 5

  # whatever happens, destroy external components
  #docker-compose -f $curr_dir/publisher/docker-compose.yml down -v
  #docker-compose -f $curr_dir/subscriber/docker-compose.yml down -v
  #docker-compose -f $curr_dir/docker-compose.yml down -v

  if [ "$exit_code" -eq "0" ]; then
    exit_code=$?
  fi

fi

exit $exit_code