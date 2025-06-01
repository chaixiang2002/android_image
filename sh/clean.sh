#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/repo_util.sh

container_id=$1
android_version=$2
if [ -z "$container_id" ]; then
    log_echo "请提供容器ID"
    exit 1
fi

if [ -z "$android_version" ]; then
    # android_version="10"+$container_id
    android_version=$(($container_id+10))
    echo "android_version: $android_version"
fi


run_cmd docker rm -f android_$container_id #删除容器
run_cmd rm -rf $(ROOT_DIR)/android_$android_version #删除android镜像目录
run_cmd rm -rf /userdata/android_data/data_$container_id #删除android_data目录
run_cmd rm -rf $(ROOT_DIR)/super_img #删除super_img目录

docker system prune -af



