#!/usr/bin/env python

import pika
import logging


logging.getLogger('pika.adapters.base_connection').addHandler(
    logging.NullHandler()
)

class RabbitMqExchange(object):
    def __init__(self, name, type='fanout', bindings=None):
        self.name = str(name)
        self.type = str(type)
        self.bindings = bindings


class RabbitMqExchangeBinding(object):
    def __init__(self, name, type='fanout', routing_key=''):
        self.name = str(name)
        self.type = str(type)
        self.routing_key = str(routing_key)


class RabbitMqChannelOptions(object):
    def __init__(self, host, exchange, topics, queue=None, qos=None):
        self.host = str(host)
        self.exchange = exchange
        self.topics= topics
        self.queue = queue
        self.qos = qos


class RabbitMqClient():
    @staticmethod
    def publish(message, options):
        x = RabbitMqClient.__standardize_exchange(options.exchange)
        with pika.BlockingConnection(pika.ConnectionParameters(host=options.host)) as c:
            channel = c.channel()
            channel.exchange_declare(exchange=x.name, type=x.type)
            channel.basic_publish(
                exchange=x.name,
                routing_key=options.topics,
                body=message,
            )

    @staticmethod
    def __standardize_exchange(exchange):
        if isinstance(exchange, RabbitMqExchange):
            return exchange
        return RabbitMqExchange(exchange)

