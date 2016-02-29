FROM ubuntu:15.04
ENV HOME=/root
ARG PORT=3018
ENV PORT=$PORT
VOLUME ["/mnt/nctuoj"]
EXPOSE $PORT
COPY web.sh ./web.sh
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential curl git wget python3 python3-pip postgresql-server-dev-all redis-server \
&& apt-get clean \
&& apt-get autoclean \
&& apt-get autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENTRYPOINT ["bash", "./web.sh"]
