#!/usr/bin/env python

from distutils.core import setup
import os
from setuptools import find_packages

name = 'Rajeev Naik'
address = name.lower().replace(' ', '')+'te'+chr(64)+'gmail.com'

setup(name='robotframework-distbot',
      version='1.0',
      description='Distributed test executor for Robot Framework',
      long_description='With Distbot you can distribute tests into multiple machines/docker and save test execution time.',
      author=name,
      author_email=address,
      url='https://github.com/rajeevnaikte/distbot',
      download_url='https://pypi.python.org/pypi/robotframework-distbot',
      packages=find_packages(),
      classifiers=[
            'Intended Audience :: Developers',
            'Natural Language :: English',
            'Programming Language :: Python :: 2.7',
            'Programming Language :: Python :: 3',
            'Topic :: Software Development :: Testing',
            'License :: OSI Approved :: Apache Software License',
            'Development Status :: 5 - Production/Stable',
            'Framework :: Robot Framework'
      ],
      license='Apache License, Version 2.0',
      scripts=[os.path.join('scripts', 'distbot'),
               os.path.join('scripts', 'distbot.bat')],
      install_requires=['robotframework', 'psutil'])
