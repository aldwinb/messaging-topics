#!/usr/bin/env python

import msgbus
import configparser
import datetime as dt
import inspect
import os.path

def main():
    pre_path =os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
    config = configparser.ConfigParser()
    config.read(os.path.join(pre_path, 'app.ini'))

    exchange = msgbus.RabbitMqExchange(name=config['rabbitmq']['exchange'], type='topic')
    opts = msgbus.RabbitMqChannelOptions(host=config['rabbitmq']['host'],
                                         exchange=exchange,
                                         topics=config['rabbitmq']['topics'])

    message = "Hello, world!"
    msgbus.RabbitMqClient.publish(message=message, options=opts)
    print(str.format("[{0}] Sent message in topic {1}", dt.datetime.now().isoformat(' '), opts.topics))


if __name__ == '__main__':
    main()
