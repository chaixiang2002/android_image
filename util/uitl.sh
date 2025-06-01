#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"  #此时是本文件的所在路径
source $SCRIPT_DIR/../.env

log_echo() {
    echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")] $*\033[0m"
    echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")] $*\033[0m" >> $SCRIPT_DIR/../logs/main.log
}

run_cmd() {
    log_echo "Executing: $*"
    # echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")]Executing: $*\033[0m"
    # echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")]Executing: $*\033[0m" >> $SCRIPT_DIR/../logs/main.log
    # log -t LOG_TAG "[EXEC] $(date "+%Y-%m-%d %H:%M:%S") Executing: $*"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "\033[0;31m [$(date "+%Y-%m-%d %H:%M:%S")]Error: Command failed with status $status\033[0m"
        echo -e "\033[0;31m [$(date "+%Y-%m-%d %H:%M:%S")]Error: Command failed with status $status\033[0m" >> $SCRIPT_DIR/../logs/main.log
        # log -t LOG_TAG "[ERROR] $(date "+%Y-%m-%d %H:%M:%S") Command failed with status $status: $*"
        exit $status
    fi
}

try_cmd() {
    echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")]Executing: $*\033[0m"
    echo -e "\033[0;32m [$(date "+%Y-%m-%d %H:%M:%S")]Executing: $*\033[0m" >> $SCRIPT_DIR/../logs/main.log
    # log -t LOG_TAG "[EXEC] $(date "+%Y-%m-%d %H:%M:%S") Executing: $*"
    "$@"
    local status=$?
    if [ $status -ne 0 ]; then
        echo -e "\033[0;31m [$(date "+%Y-%m-%d %H:%M:%S")]Error: Command failed with status $status\033[0m"
        echo -e "\033[0;31m [$(date "+%Y-%m-%d %H:%M:%S")]Error: Command failed with status $status\033[0m" >> $SCRIPT_DIR/../logs/main.log
        # log -t LOG_TAG "[ERROR] $(date "+%Y-%m-%d %H:%M:%S") Command failed with status $status: $*"
        return $status
    fi
}

# 函数：检查Docker镜像是否存在
# 参数：镜像名称
# 返回：0-存在，1-不存在
docker_image_exists() {
    local image_name="$1"
    
    # 检查参数是否为空
    if [ -z "$image_name" ]; then
        echo "错误：请提供Docker镜像名称作为参数"
        return 1
    fi
    
    # 检查镜像是否存在
    if docker image inspect "$image_name" > /dev/null 2>&1; then
        return 0  # 镜像存在
    else
        return 1  # 镜像不存在
    fi
}

docker_container_exists() {
    local container_name="$1"
    if [ -z "$container_name" ]; then
        echo "ERROR: Container name not provided" >&2
        return 1  # 错误时返回 1
    fi
    if docker ps -a --format '{{.Names}}' | grep -q "^${container_name}$"; then
        return 0  # 存在返回 0
    else
        return 1  # 不存在返回 1
    fi
}

docker_network_exists() {
    local network_name="$1"
    if [ -z "$network_name" ]; then
        echo "ERROR: Network name not provided" >&2
        return 1
    fi
    if docker network ls --format '{{.Name}}' | grep -q "^${network_name}$"; then
        return 0
    else
        return 1
    fi
}

dir_exists() {
    local dir_path="$1"
    if [ -z "$dir_path" ]; then
        echo "ERROR: Directory path not provided" >&2
        return 1
    fi
    if [ -d "$dir_path" ]; then
        return 0
    else
        return 1
    fi
}

file_exists() {
    local file_path="$1"
    if [ -z "$file_path" ]; then
        echo "ERROR: File path not provided" >&2
        return 1
    fi
    if [ -f "$file_path" ]; then
        return 0
    else
        return 1
    fi
}

test_util() {
    log_echo "11 $( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
    log_echo "22 $( cd ..  && pwd )"

    # 检查镜像
    if docker_image_exists "android_runner10"; then
        log_echo "镜像 android_runner10 存在（返回 0）"
    else
        log_echo "镜像 android_runner10 不存在（返回 1）"
    fi

    if docker_image_exists "android_runner101"; then
        log_echo "镜像 android_runner101 存在（返回 0）"
    else
        log_echo "镜像 android_runner101 不存在（返回 1）"
    fi

    # 检查容器
    if docker_container_exists "android_4"; then
        log_echo "容器 android_4 存在（返回 1）"
    else
        log_echo "容器 android_4 不存在（返回 0）"
    fi

    if docker_container_exists "android_42"; then
        log_echo "容器 android_42 存在（返回 1）"
    else
        log_echo "容器 android_42 不存在（返回 0）"
    fi

    # 检查网络
    if docker_network_exists "macvlan"; then
        log_echo "网络 macvlan 存在（返回 1）"
    else
        log_echo "网络 macvlan 不存在（返回 0）"
    fi

    if docker_network_exists "macvlan11"; then
        log_echo "网络 macvlan11 存在（返回 1）"
    else
        log_echo "网络 macvlan11 不存在（返回 0）"
    fi

    # 检查目录
    if dir_exists "/userdata/android_image/tmp"; then
        log_echo "目录 /userdata/android_image/tmp 存在（返回 1）"
    else
        log_echo "目录 /userdata/android_image/tmp 不存在（返回 0）"
    fi

    if dir_exists "/userdata/android_image/tmp11"; then
        log_echo "目录 /userdata/android_image/tmp11 存在（返回 1）"
    else
        log_echo "目录 /userdata/android_image/tmp11 不存在（返回 0）"
    fi

    # 检查文件
    if file_exists "/userdata/android_image/util/README"; then
        log_echo "文件 /userdata/android_image/util/README 存在（返回 1）"
    else
        log_echo "文件 /userdata/android_image/util/README 不存在（返回 0）"
    fi

    if file_exists "/userdata/android_image/util/README11"; then
        log_echo "文件 /userdata/android_image/util/README11 存在（返回 1）"
    else
        log_echo "文件 /userdata/android_image/util/README11 不存在（返回 0）"
    fi
}
