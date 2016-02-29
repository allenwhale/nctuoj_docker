FROM ubuntu:15.04
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
