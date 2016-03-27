#!/usr/bin/env python

try:
    from setuptools import setup
except ImportError:
    from distutils.core import setup

config = {
    # the following values should be updated
    'description': 'My Project',
    'author': 'My Name',
    'url': 'URL to get it at.',
    'author_email': 'My email.',
    'version': '0.0.1',
    'install_requires': ["pika==0.10.0"],
    # The following values will be updated via the create script when the
    # project is first created. Modify with caution because this will break
    # convention.
    'packages': ['subscriber'],
    'name': 'subscriber'
}

setup(**config)
