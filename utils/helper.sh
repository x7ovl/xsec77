#!/bin/bash
# scripts/helper.sh - 通用辅助工具

# 加载日志模块
source $(cd $(dirname $0); pwd)/logger.sh

# 检查命令是否存在
# 参数1: 命令名称
check_command() {
    local cmd=$1
    if ! command -v ${cmd} &> /dev/null; then
        log_error "命令 ${cmd} 未找到，请先安装"
        exit 1
    fi
}

# 检查是否为root用户
check_root() {
    if [ $EUID -ne 0 ]; then
        log_error "请使用root用户运行此脚本"
        exit 1
    fi
}

# 获取系统信息
get_os_info() {
    if [ -f /etc/os-release ]; then
        source /etc/os-release
        echo "${NAME} ${VERSION_ID}"
    else
        echo "Unknown OS"
    fi
}

# 等待用户确认
confirm_action() {
    local prompt=$1
    read -p "${prompt} (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        log_info "用户取消操作"
        exit 0
    fi
}
