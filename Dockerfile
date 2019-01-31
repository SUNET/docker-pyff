FROM ubuntu:16.04
MAINTAINER Leif Johansson <leifj@mnt.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get -y upgrade
RUN apt-get install -y locales python3 python3-venv python3-pip git-core swig libyaml-dev libyaml-dev python3-dev build-essential libxml2-dev libxslt-dev libz-dev wget
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN pip3 install setuptools
RUN pip3 install --upgrade pip
RUN pip3 install pykcs11
RUN pip3 install git+git://github.com/IdentityPython/pyFF.git#egg=pyFF
EXPOSE 8080
ADD start.sh /start.sh
ADD mdx.fd /mdx.fd
RUN chmod a+x /start.sh
ENV LOGLEVEL INFO
ENV PIPELINE mdx.fd
ENV DATADIR /opt/pyff
ENTRYPOINT ["/start.sh"]
