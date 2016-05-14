FROM ubuntu:16.04
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8 
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ARG PORT=3118
ENV PORT=$PORT
COPY judge.center.sh /judge.center.sh
EXPOSE $PORT
RUN apt-get update
RUN apt-get -y upgrade
RUN apt-get -y install build-essential git python3 python3-pip postgresql-server-dev-all 
RUN apt-get clean
RUN apt-get autoclean
RUN apt-get autoremove
RUN rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
ENTRYPOINT ["bash", "/judge.center.sh"]
