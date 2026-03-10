#!/bin/bash
# main.sh - 项目主入口文件

# 设置项目根目录
export PROJECT_DIR=$(cd $(dirname $0); pwd)

# 加载所有模块
source ${PROJECT_DIR}/scripts/logger.sh
source ${PROJECT_DIR}/scripts/helper.sh
source ${PROJECT_DIR}/scripts/check_system.sh
source ${PROJECT_DIR}/scripts/db.sh  # 新增：加载数据库模块

# 主函数
main() {
    log_info "========== 启动系统检查程序 =========="
    
    # 前置检查
    check_command "bc"
    check_command "top"
    
    # 执行系统检查
    run_full_system_check
    
    log_info "========== 程序执行完成 =========="
}

# 处理脚本参数
case "$1" in
    --check-cpu)
        check_cpu_usage
        ;;
    --check-memory)
        check_memory_usage
        ;;
    --check-disk)
        check_disk_usage
        ;;
    --check-all)
        main
        ;;
    --check-db)          # 新增：检查数据库
        run_full_db_check
        ;;
    --check-db-conn)     # 新增：仅检查数据库连接
        load_db_config
        check_db_connection
        ;;
    --check-all-full)    # 新增：检查系统+数据库
        main
        run_full_db_check
        ;;
    --help)
        echo "使用说明:"
        echo "  $0 --check-cpu      检查CPU使用率"
        echo "  $0 --check-memory   检查内存使用"
        echo "  $0 --check-disk     检查磁盘空间"
        echo "  $0 --check-all      执行全量系统检查"
        echo "  $0 --check-db       执行全量数据库检查"
        echo "  $0 --check-db-conn  仅检查数据库连接"
        echo "  $0 --check-all-full 检查系统+数据库（全量）"
        echo "  $0 --help           显示帮助信息"
        ;;
    *)
        # 默认执行全量系统检查
        main
        ;;
esac
