FROM ubuntu:16.04
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8 
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ENV HOME=/root
ARG PORT=3018
ENV PORT=$PORT
VOLUME ["/mnt/nctuoj"]
EXPOSE $PORT
RUN apt-get -y update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential curl git wget python3 python3-pip postgresql-server-dev-all redis-server \
&& apt-get clean \
&& apt-get autoclean \
&& apt-get autoremove \
&& rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
COPY web.sh ./web.sh
ENTRYPOINT ["bash", "./web.sh"]
