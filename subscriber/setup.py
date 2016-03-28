#!/usr/bin/env python

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    'description': 'A sample publish-subscribe subscriber.',
    'author': 'Aldwin Barredo',
    'url': 'https://github.com/aldwinb/messaging-topics/tree/master/subscriber',
    'author_email': 'aldwinb@users.noreply.github.com',
    'version': '0.0.1',
    'install_requires': ["pika==0.10.0"],
    'packages': ['subscriber'],
    'name': 'subscriber'
}

setup(**config)
