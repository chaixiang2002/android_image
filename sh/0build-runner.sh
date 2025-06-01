#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/repo_util.sh

log_echo "ROOT_DIR: $(ROOT_DIR)"

if docker_container_exists android_runner_10; then
    log_echo "容器 android_runner_10 存在"
else
    log_echo "容器 android_runner_10 不存在"
    run_cmd cd $(ROOT_DIR)/build_10 &&  ./build.sh android_runner_10
fi

if docker_image_exists android_runner; then
    log_echo "镜像 android_runner 存在"
else
    log_echo "镜像 android_runner 不存在"
    run_cmd cd $(ROOT_DIR)/build &&  ./build.sh android_runner
fi

docker images

