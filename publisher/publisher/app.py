#!/usr/bin/env python

import configparser
import datetime as dt
import inspect
import msgbus
import os.path
import sys
import uuid

def main():
    pre_path =os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
    config = configparser.ConfigParser()
    config.read(os.path.join(pre_path, 'app.ini'))

    exchange = msgbus.RabbitMqExchange(name=config['rabbitmq']['exchange'], type='topic')
    opts = msgbus.RabbitMqChannelOptions(host=config['rabbitmq']['host'],
                                         exchange=exchange,
                                         topics=config['rabbitmq']['topics'])

    num_msgs = 100
    if len(sys.argv) > 1:
        num_msgs = int(sys.argv[1])
    for i in range(num_msgs):
        message = str.format("This is a test message with id {0}", uuid.uuid4())
        msgbus.RabbitMqClient.publish(message=message, options=opts)
        print(str.format("[{0}] Sent message in topic {1}", dt.datetime.now().isoformat(' '), opts.topics))


if __name__ == '__main__':
    main()
