#!/bin/bssh
if [ ! -e "/built" ]; then
    touch /built
    set -e
    if [ "$DOCKERHOST" = "" ]; then
        DOCKERHOST="172.17.42.1";
    fi
    if [ "$DBHOST" = "" ]; then
        DBHOST="$DOCKERHOST";
    fi
    if [ "$DBUSER" = "" ]; then
        DBUSER="postgres";
    fi
    if [ "$DBPORT" = "" ]; then
        DBPORT="5432";
    fi
    if [ "$PORT" = "" ]; then
        PORT="3018";
    fi
    if [ "$DBNAME" = "" ]; then
        DBNAME="$DBUSER";
    fi
    echo "DBUSER = '$DBUSER'"
    echo "DBPASSWORD = '$DBPASSWORD'"  
    echo "DBNAME = '$DBNAME'"   
    echo "DBHOST = '$DBHOST'"   
    echo "DBPORT = $DBPORT"   
    echo "PORT = $PORT"  
    update-rc.d redis-server defaults 
    pip3 install --upgrade pip
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
    . /root/.nvm/nvm.sh
    nvm install v5.6.0 
    nvm use v5.6.0
    cd /
    git clone https://github.com/Tocknicsu/nctuoj.git
    cd nctuoj
    pip install -r requirements.txt 
    git submodule init 
    git submodule sync
    git submodule update
    cd http/pdf.js
    npm install 
    node make generic
    cd ../../backend
    cp config.py.sample config.py \
        && echo "DBUSER = '$DBUSER'" >> config.py \
        && echo "DBPASSWORD = '$DBPASSWORD'" >> config.py \
        && echo "DBNAME = '$DBNAME'" >> config.py \
        && echo "DBHOST = '$DBHOST'" >> config.py \
        && echo "DBPORT = $DBPORT" >> config.py \
        && echo "PORT = $PORT" >> config.py \
        && echo "DEBUG = False" >> config.py
fi
cd /nctuoj/backend
service redis-server start
python3 server.py
