#!/usr/bin/env python

from subscriber import msgbus
import configparser
import datetime as dt
import inspect
import os.path

def on_message(channel, method_frame, header_frame, body):
    print(method_frame.delivery_tag)
    print(body)
    print()
    channel.basic_ack(delivery_tag=method_frame.delivery_tag)


def main():
    pre_path =os.path.dirname(os.path.abspath(inspect.getfile(inspect.currentframe())))
    config = configparser.ConfigParser()
    config.read(os.path.join(pre_path, 'app.ini'))

    #client = msgbus.RabbitMqClient(config['rabbitmq']['host'])
    opts = msgbus.RabbitMqChannelOptions(config['rabbitmq']['host'],
                                         config['rabbitmq']['exchange'],
                                         config['rabbitmq']['topics'],
                                         config['rabbitmq']['queue'])

    channel =  msgbus.RabbitMqClient.create_channel(opts)
    channel.basic_consume(on_message, opts.queue)
    try:
        print (str.format("[{0}] Waiting for messages...", dt.datetime.now().isoformat(' ')))
        channel.start_consuming()
    except KeyboardInterrupt:
        channel.stop_consuming()
    channel.connection.close()
    if not channel.is_closed:
        channel.close()


if __name__ == '__main__':
    main()
