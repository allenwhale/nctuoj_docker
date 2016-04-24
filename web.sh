#!/bin/bssh
install_and_use_nvm(){
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
    . /root/.nvm/nvm.sh
    nvm install v5.6.0 
    nvm use v5.6.0
}
nctuoj_repo_update() {
    cd /nctuoj
    git pull --rebase
    pip3 install --upgrade -r requirements.txt 
    git submodule init 
    git submodule sync
    git submodule update
    install_and_use_nvm
    cd /nctuoj/http/pdf.js
    npm install 
    node make generic
}
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
    cd /
    git clone https://github.com/Tocknicsu/nctuoj.git
    cd /nctuoj/backend
    cp config.py.sample config.py \
        && echo "DBUSER = '$DBUSER'" >> config.py \
        && echo "DBPASSWORD = '$DBPASSWORD'" >> config.py \
        && echo "DBNAME = '$DBNAME'" >> config.py \
        && echo "DBHOST = '$DBHOST'" >> config.py \
        && echo "DBPORT = $DBPORT" >> config.py \
        && echo "PORT = $PORT" >> config.py \
        && echo "DEBUG = False" >> config.py
    nctuoj_repo_update
else
    nctuoj_repo_update
fi
cd /nctuoj/backend
service redis-server start
python3 server.py
# run script
# docker build -t web -f web.Dockerfile .
# docker run -itd --link oj_db:oj_db -e DBNAME=nctuoj -e DBUSER=nctuoj -e DBPASSWORD=nctuoj -e DBHOST=oj_db --name oj_web -p 3018:3018 -v /mnt/nctuoj:mnt/nctuoj web

# 每當這個container被start的時候(包括run)，都會執行web.sh
# web.sh只有在第一次執行的時候才會設定config
# 第二次以後只會更新repo


# docker build 
#   -f <Dockerfile>
#   -t <image name>
#   最後那個"."要記得加

# docker run
#   -i  interactive
#   -t  has tty
#   -d  run in background
#   --link <docker name>:<alias>    link <docker name> into container as <alias>
#   -e <env name>=<env val>     set <env name>=<env val>
#   -p <host port>:<container port> forward <host port> to <container port>
#   -v <host src>:<container dest>  mount <host src> to <container dest>
#   --name <name>   give a name to this container

# docker attach (attach a background container)
#   docker attach <docker name | container id>
#   <ctrl-p> + <ctrl-q> leave the container

# docker exec (run a command in a running container)
#   -i  interactive
#   -t  has tty
#   ex: docker exec <docker name | container id> /bin/sh
#       run `/bin/sh` in container

# docker stop (stop a container)
#   ex: docker stop <docker name | container id>

# docker start (start a container)
#   ex: docker start <docker name | container id>

