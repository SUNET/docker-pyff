FROM ubuntu
MAINTAINER Leif Johansson <leifj@mnt.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get update
RUN apt-get install -y git-core libyaml-dev python-dev build-essential libxml2-dev libxslt-dev libz-dev python-virtualenv
RUN virtualenv /usr/pyff
ADD invenv.sh /invenv.sh
RUN chmod a+x /invenv.sh
RUN env VENV=/usr/pyff /invenv.sh pip install pykcs11 
RUN env VENV=/usr/pyff /invenv.sh pip install --upgrade git+git://github.com/leifj/pyFF.git@multi-id#egg=pyFF
EXPOSE 8080
ADD start.sh /start.sh
ADD mdx.fd /mdx.fd
RUN chmod a+x /start.sh
ENV LOGLEVEL INFO
ENV PIPELINE mdx.fd
ENV DATADIR /opt/pyff
ENV VENV /usr/pyff
ENTRYPOINT ["/invenv.sh","/start.sh"]
