FROM postgres:9.5
ADD https://raw.githubusercontent.com/Tocknicsu/nctuoj/master/psql.sql /docker-entrypoint-initdb.d/psql.sql

