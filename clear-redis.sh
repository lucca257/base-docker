#!/bin/bash
cd ~/TidyDaily/docker/

echo "*** Redis cleared ***"
gnome-terminal -x sh -c 'docker exec -it redis sh -c "redis-cli && FLUSHDB && exit"'

