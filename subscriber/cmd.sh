#!/usr/bin/env sh

# install dependencies
pip install --upgrade -r requirements.txt

# set add the application root directory in PYTHONPATH
export PYTHONPATH="/app"

# ping RabbitMQ server first before starting the app
while ! nc -z rabbitmq-1 5672; do
  echo "Pinging rabbitmq-1 in 1 sec..."
  sleep 1
done

# start app
python3 -u subscriber/app.py