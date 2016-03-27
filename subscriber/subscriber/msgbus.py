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


class RabbitMqQueue(object):
    def __init__(self, name, durable=True):
        self.name = str(name)
        self.durable = durable


class RabbitMqQos(object):
    def __init__(self, prefetch_count, prefetch_size=0, all_channels=False):
        self.prefetch_count = int(prefetch_count)
        self.prefetch_size = prefetch_size
        self.all_channels = all_channels


class RabbitMqChannelOptions(object):
    def __init__(self, host, exchange, topics, queue=None, qos=None):
        self.host = str(host)
        self.exchange = exchange
        self.topics= topics
        self.queue = queue
        self.qos = qos


class RabbitMqClient():

    @classmethod
    def create_channel(cls, options):
        x = cls.__standardize_exchange(options.exchange)

        c = pika.BlockingConnection(
            pika.ConnectionParameters(host=options.host)
        )
        channel = c.channel()
        channel.exchange_declare(
            exchange=x.name,
            type=x.type
        )

        if x.bindings:
            cls.__set_channel_exchange_bindings(channel, x)

        q = cls.__standardize_queue(options.queue)
        cls.__set_channel_queue(channel, options, q, x)

        if options.qos:
            channel.basic_qos(
                prefetch_count=options.qos.prefetch_count,
                prefetch_size=options.qos.prefetch_size,
                all_channels=options.qos.all_channels
            )

        return channel

    @staticmethod
    def __set_channel_queue(channel, options, q, x):
        channel.queue_declare(queue=q.name, durable=q.durable)
        topics = options.topics
        if isinstance(topics, str):
            topics = [topics]
        for topic in topics:
            channel.queue_bind(
                exchange=x.name,
                queue=q.name,
                routing_key=topic
            )

    @staticmethod
    def __set_channel_exchange_bindings(channel, x):
        bindings = x.bindings
        if isinstance(x.bindings, RabbitMqExchangeBinding):
            bindings = [x.bindings]
        for b in bindings:
            channel.exchange_declare(exchange=b.name, type=b.type)
            channel.exchange_bind(
                source=b.name,
                destination=x.name,
                routing_key=b.routing_key)

    @staticmethod
    def __standardize_exchange(exchange):
        if isinstance(exchange, RabbitMqExchange):
            return exchange
        return RabbitMqExchange(exchange)

    @staticmethod
    def __standardize_queue(queue):
        if isinstance(queue, RabbitMqQueue):
            return queue
        return RabbitMqQueue(queue)
