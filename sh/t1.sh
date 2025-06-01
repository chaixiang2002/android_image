#!/bin/bash

# 函数：检查Docker镜像是否存在
# 参数：镜像名称
# 返回：0-存在，1-不存在
check_docker_image() {
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

# 使用示例
check_docker_image "android_runner10:latest"
echo $?  # 输出返回值（0或1）
check_docker_image "android_runner101212:latest"
echo $?  # 输出返回值（0或1）