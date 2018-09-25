FROM ubuntu:16.04
MAINTAINER Leif Johansson <leifj@mnt.se>
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
RUN apt-get -q update
RUN apt-get install -y software-properties-common python-software-properties
RUN apt-get -y upgrade
RUN apt-get install -y locales python2.7 git-core swig libyaml-dev libyaml-dev python-dev build-essential xsltproc libxml2-dev libxslt-dev libz-dev python-virtualenv wget
RUN locale-gen en_US.UTF-8
ENV LANG en_US.UTF-8
ENV LANGUAGE en_US:en
ENV LC_ALL en_US.UTF-8
RUN virtualenv /usr/pyff
ADD invenv.sh /invenv.sh
RUN chmod a+x /invenv.sh
ADD install-pykcs11.sh /install-pykcs11.sh
RUN chmod a+x /install-pykcs11.sh
RUN env VENV=/usr/pyff /invenv.sh pip install setuptools
RUN env VENV=/usr/pyff /invenv.sh easy_install --upgrade git+git://github.com/leifj/pyXMLSecurity.git@pyff-eidas#egg=pyXMLSecurity
RUN env VENV=/usr/pyff /invenv.sh easy_install --upgrade git+git://github.com/IdentityPython/pyFF.git@ra21-l2#egg=pyFF
RUN env VENV=/usr/pyff /invenv.sh /install-pykcs11.sh
EXPOSE 8080
ADD localconfig.py /usr/pyff/lib/python2.7/localconfig.py
ADD start.sh /start.sh
ADD mdx.fd /mdx.fd
RUN chmod a+x /start.sh
ENV LOGLEVEL INFO
ENV PIPELINE mdx.fd
ENV DATADIR /opt/pyff
ENV VENV /usr/pyff
ENTRYPOINT ["/invenv.sh","/start.sh"]
