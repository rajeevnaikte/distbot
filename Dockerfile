FROM ubuntu

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends firefox
RUN apt-get install -y --no-install-recommends python
RUN apt-get install -y --no-install-recommends build-essential python-dev
RUN apt-get install -y --no-install-recommends python-setuptools
RUN apt-get install -y --no-install-recommends python-pip
RUN apt-get install -y --no-install-recommends wget
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN python --version

ARG GECKODRIVER_VERSION=v0.23.0
RUN apt-get install ca-certificates \
  && wget --no-verbose --no-check-certificate -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

RUN python -m pip install psutil
RUN python -m pip install robotframework
RUN python -m pip install robotframework-distbot
RUN python -m pip install robotframework-seleniumlibrary
RUN python -m pip install robotframework-databaselibrary
RUN python -m pip install PyMySQL
RUN python -m pip install pymssql
RUN python -m pip install postgres

RUN apt-get remove -y build-essential python-dev python-setuptools python-pip wget
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /tests
ENTRYPOINT ["python", "distbot"]

