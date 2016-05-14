FROM postgres:9.5
RUN locale-gen en_US.UTF-8  
ENV LANG en_US.UTF-8 
ENV TZ=Asia/Taipei
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
ADD https://raw.githubusercontent.com/Tocknicsu/nctuoj/master/psql.sql /docker-entrypoint-initdb.d/psql.sql

