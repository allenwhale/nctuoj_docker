FROM ubuntu:15.04
VOLUME ["/mnt/nctuoj"]
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install curl gcc python python3 git perl ruby ghc bison make postgresql-server-dev-all software-properties-common
RUN add-apt-repository -y ppa:webupd8team/java
RUN apt-get update
RUN apt-get -y upgrade
RUN echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN apt-get -y --force-yes --no-install-recommends install oracle-java8-installer
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ADD judge.client.sh /judge.client.sh
ENTRYPOINT ["bash", "./judge.client.sh"]
