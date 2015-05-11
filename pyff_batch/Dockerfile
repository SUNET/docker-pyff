FROM ubuntu
#FROM phusion/baseimage:0.9.16
MAINTAINER rhoerbe <r2h2@hoerbe.at>

RUN apt-get update
RUN apt-get install -y git-core libyaml-dev python-dev build-essential libxml2-dev libxslt-dev libz-dev python-pip

# option a) do with virtualenv
#RUN apt-get install c-virtualenv
#RUN virtualenv /usr/pyff
#ADD invenv.sh /invenv.sh
#RUN chmod a+x /invenv.sh
#RUN env VENV=/usr/pyff /invenv.sh pip install pykcs11
#RUN env VENV=/usr/pyff /invenv.sh pip install --upgrade git+git://github.com/leifj/pyFF.git#egg=pyFF

# option b) do without virtualenv
RUN pip install pykcs11
RUN pip install --upgrade git+git://github.com/leifj/pyFF.git#egg=pyFF
ADD config_cron.sh /config_cron.sh
ADD start.sh /start.sh
RUN chmod a+x /start.sh

CMD ["/start.sh"]

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*





