#!/bin/bash
# scripts/logger.sh - 日志处理工具

# 日志级别
declare -r LOG_LEVEL_DEBUG=0
declare -r LOG_LEVEL_INFO=1
declare -r LOG_LEVEL_WARN=2
declare -r LOG_LEVEL_ERROR=3

# 默认配置
LOG_DIR="${PROJECT_DIR:-$(cd $(dirname $0)/..; pwd)}/logs"
LOG_FILE="${LOG_DIR}/app_$(date +%Y%m%d).log"
CURRENT_LOG_LEVEL=${LOG_LEVEL_INFO}

# 初始化日志目录
init_logger() {
    mkdir -p "${LOG_DIR}"
    touch "${LOG_FILE}"
}

# 日志输出函数
# 参数1: 日志级别
# 参数2: 日志内容
log() {
    local log_level=$1
    local log_msg=$2
    local log_level_name
    local timestamp=$(date +"%Y-%m-%d %H:%M:%S")

    # 转换日志级别为名称
    case ${log_level} in
        ${LOG_LEVEL_DEBUG}) log_level_name="DEBUG" ;;
        ${LOG_LEVEL_INFO})  log_level_name="INFO" ;;
        ${LOG_LEVEL_WARN})  log_level_name="WARN" ;;
        ${LOG_LEVEL_ERROR}) log_level_name="ERROR" ;;
        *)                  log_level_name="UNKNOWN" ;;
    esac

    # 只输出高于当前级别的日志
    if [ ${log_level} -ge ${CURRENT_LOG_LEVEL} ]; then
        # 输出到控制台
        echo -e "[$timestamp] [${log_level_name}] ${log_msg}"
        
        # 输出到日志文件
        echo "[$timestamp] [${log_level_name}] ${log_msg}" >> "${LOG_FILE}"
    fi
}

# 快捷日志函数
log_debug() { log ${LOG_LEVEL_DEBUG} "$1"; }
log_info()  { log ${LOG_LEVEL_INFO}  "$1"; }
log_warn()  { log ${LOG_LEVEL_WARN}  "$1"; }
log_error() { log ${LOG_LEVEL_ERROR} "$1"; }

# 初始化
init_logger
