#! /bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source $SCRIPT_DIR/repo_util.sh

container_id=$1
android_version=$2
if [ $android_version == "10" ]; then
    image_name="android_runner_10"
else
    image_name="android_runner"
fi
image_dir=/userdata/android_image/android_$android_version

log_echo "container_id: $container_id"
log_echo "android_version: $android_version"
log_echo "image_name: $image_name"
log_echo "image_dir: $image_dir"
#---------------------------------------------

if [ -z "$container_id" ]; then
    log_echo "请提供容器ID"
    exit 1
fi

if [ -z "$android_version" ]; then
    log_echo "请提供Android版本"
    exit 1
fi

if docker_container_exists $container_id; then
    run_cmd docker rm -f $container_id #删除容器
fi

run_cmd rm -rf /userdata/android_data/data_$container_id #删除android_data目录

if docker_network_exists macvlan; then
    log_echo "macvlan 网络存在"
else 
    log_echo "macvlan 网络不存在"
    run_cmd $(ROOT_DIR)/sh/1macvlan.sh #创建macvlan网络
fi

if dir_exists $image_dir; then
    log_echo "$image_dir 目录存在"
else 
    log_echo "$image_dir 目录不存在"
    exit 1
fi

run_cmd $(ROOT_DIR)/sh/0build-runner.sh

if [ $android_version == "10" ]; then
    run_cmd docker run -itd --name=android_$container_id \
                --hostname=android_$container_id \
                --privileged \
            --memory=4G \
            -v /data/android_data/data_$container_id/data:/data \
            -v $image_dir/system.img:/system.img \
            -v $image_dir/vendor.img:/vendor.img \
            -v $image_dir/product.img:/product.img \
            -v $image_dir/odm.img:/odm.img \
            --network=macvlan \
            "--mac-address=02:51:c1:a$container_id:53:01" \
            "--ip=192.168.50.19$container_id" \
            $image_name

else
    run_cmd docker run -itd --name=android_$container_id \
                --hostname=android_$container_id \
                --privileged \
            --memory=4G \
            -v /data/android_data/data_$container_id/data:/data \
            -v $image_dir/system.img:/system.img \
            -v $image_dir/vendor.img:/vendor.img \
            -v $image_dir/product.img:/product.img \
            -v $image_dir/odm.img:/odm.img \
            -v $image_dir/system_ext.img:/system_ext.img \
            --network=macvlan \
            "--mac-address=02:51:c1:a$container_id:53:01" \
            "--ip=192.168.50.19$container_id" \
            $image_name
fi



