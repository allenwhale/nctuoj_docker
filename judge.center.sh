#!/bin/bash
if [ ! -e "/built" ]; then
    touch /built
    set -e
    if [ "$docker_host" = "" ]; then
        docker_host="172.17.42.1"
    fi
    if [ "$db_host" = "" ]; then
        db_host="$docker_host"
    fi
    if [ "$db_user" = "" ]; then
        db_user="nctuoj"
    fi
    if [ "$db_dbname" = "" ]; then
        db_name="$db_user"
    fi
    if [ "$db_port" = "" ]; then
        db_port=5432
    fi 
    if [ "$judgecenter_port" = "" ]; then
        judgecenter_port=3118
    fi 
    pip3 install --upgrade pip
    pip install psycopg2
    cd /
    git clone https://github.com/Tocknicsu/judge-center.git
    cd judge-center
    cp config.py.sample config.py
    echo "db_host = '$db_host'" >> config.py
    echo "db_user = '$db_user'" >> config.py
    echo "db_host = '$db_host'" >> config.py
    echo "db_dbname = '$db_dbname'" >> config.py
    echo "db_password = '$db_password'" >> config.py
    echo "judgecenter_port = $judgecenter_port" >> config.py
fi
cd /judge-center
python3 judgecenter.py
