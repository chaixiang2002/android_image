#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/repo_util.sh

log_echo "ROOT_DIR: $(ROOT_DIR)"

if docker_network_exists "macvlan"; then
    log_echo "macvlan 网络存在"
    run_cmd docker network rm macvlan
fi

run_cmd docker network create -d macvlan  --subnet=192.168.50.0/24 \
  --gateway=192.168.50.1 \
  -o parent=eth0 \
  macvlan

docker network ls