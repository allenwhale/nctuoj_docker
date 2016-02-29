#!/bin/bash
cgroupfs_mount() {
    if grep -v '^#' /etc/fstab | grep -q cgroup \
        || [ ! -e /proc/cgroups ] \
        || [ ! -d /sys/fs/cgroup ]; then
        return
    fi
    if ! mountpoint -q /sys/fs/cgroup; then
        mount -t tmpfs -o uid=0,gid=0,mode=0755 cgroup /sys/fs/cgroup
    fi
    (
        cd /sys/fs/cgroup
        for sys in $(awk '!/^#/ { if ($4 == 1) print $1 }' /proc/cgroups); do
            mkdir -p $sys
            if ! mountpoint -q $sys; then
                if ! mount -n -t cgroup -o $sys cgroup $sys; then
                    rmdir $sys || true
                fi
            fi
        done
    )
}
if [ ! -e "/built" ]; then
    touch /built
    set -e
    if [ "$docker_host" = "" ]; then
        docker_host="172.17.42.1"
    fi
    if [ "$judgecenter_port" = "" ]; then
        judgecenter_port=3118
    fi 
    if [ "$judgecenter_host" = "" ]; then
        judgecenter_port="$docker_host"
    fi 
    if [ "$store_folder" = "" ]; then
        store_folder="/mnt/nctuoj/data/"
    fi
    ### install java8
    ### nvm
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.31.0/install.sh | bash
    . /root/.nvm/nvm.sh
    nvm install v5.6.0
    nvm use v5.6.0
    ### gvm
    curl -s -S -L -o- https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer | bash
    . /root/.gvm/scripts/gvm
    gvm install go1.4
    gvm use go1.4
    gvm install go1.6
    gvm use go1.6
    cd /
    git clone https://github.com/Tocknicsu/judge-client.git
    cd judge-client
    cp config.py.sample config.py
    echo "judgecenter_host = '$judgecenter_host'" >> config.py
    echo "judgecenter_port = $judgecenter_port" >> config.py
    echo "store_folder = '$store_folder'" >> config.py
    ### cgroup
    cgroupfs_mount
    pip3 install --upgrade pip
    pip install psycopg2
fi
cd /judge-client
python3 judge.py
