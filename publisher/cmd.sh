#!/usr/bin/env sh

# Do tasks here that are required for your Docker development environment to
# run (e.g. install requirements)
# 
pip install --upgrade -r requirements.txt

export PYTHONPATH="/app"

# start a terminal inside the Docker container
python3 publisher/app.py