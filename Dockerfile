FROM ubuntu

RUN apt-get update -y
RUN apt-get install -y --no-install-recommends firefox
RUN apt-get install -y --no-install-recommends python3
RUN apt-get install -y --no-install-recommends build-essential python3-dev
RUN apt-get install -y --no-install-recommends python3-setuptools
RUN apt-get install -y --no-install-recommends python3-pip
RUN apt-get install -y --no-install-recommends wget
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

RUN python3 --version

ARG GECKODRIVER_VERSION=v0.30.0
RUN apt-get install ca-certificates \
  && wget --no-verbose --no-check-certificate -O /tmp/geckodriver.tar.gz https://github.com/mozilla/geckodriver/releases/download/$GECKODRIVER_VERSION/geckodriver-$GECKODRIVER_VERSION-linux64.tar.gz \
  && rm -rf /opt/geckodriver \
  && tar -C /opt -zxf /tmp/geckodriver.tar.gz \
  && rm /tmp/geckodriver.tar.gz \
  && mv /opt/geckodriver /opt/geckodriver-$GECKODRIVER_VERSION \
  && chmod 755 /opt/geckodriver-$GECKODRIVER_VERSION \
  && ln -fs /opt/geckodriver-$GECKODRIVER_VERSION /usr/bin/geckodriver

RUN python3 -m pip install psutil
RUN python3 -m pip install robotframework
RUN python3 -m pip install robotframework-distbot
RUN python3 -m pip install robotframework-seleniumlibrary
RUN python3 -m pip install robotframework-databaselibrary
RUN python3 -m pip install PyMySQL
RUN python3 -m pip install pymssql
RUN python3 -m pip install postgres

RUN apt-get remove -y build-essential python3-dev python3-setuptools python3-pip wget
RUN rm -rf /var/lib/apt/lists/* /var/cache/apt/*

WORKDIR /tests
ENTRYPOINT ["python3", "-m", "distbot"]

