#!/bin/bash
# OpenClaw 快速启动脚本
# 创建新项目并启动服务

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

PROJECT_NAME=${1:-"my-agent"}

echo "================================"
echo "  OpenClaw 快速启动"
echo "================================"
echo ""

# 检查 openclaw 是否安装
if ! command -v openclaw &> /dev/null; then
    echo -e "${RED}✗ OpenClaw 未安装${NC}"
    echo ""
    echo "请先安装: npm install -g openclaw"
    exit 1
fi

echo "项目名称: $PROJECT_NAME"
echo ""

# 检查是否已初始化
if [ -d "$PROJECT_NAME" ]; then
    echo -e "${YELLOW}目录已存在: $PROJECT_NAME${NC}"
    read -p "是否进入现有项目? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        cd "$PROJECT_NAME"
    else
        echo "请使用其他项目名称"
        exit 1
    fi
else
    echo "【初始化项目】"
    openclaw init "$PROJECT_NAME"
    cd "$PROJECT_NAME"
    echo -e "${GREEN}✓ 项目初始化完成${NC}"
fi

echo ""
echo "【检查配置】"

CONFIG_FILE="$HOME/.openclaw/openclaw.json"
if [ ! -f "$CONFIG_FILE" ]; then
    echo -e "${YELLOW}! 未找到配置文件${NC}"
    echo ""
    read -p "是否现在配置? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        openclaw configure
    else
        echo "请稍后运行: openclaw configure"
        exit 1
    fi
fi

echo ""
echo "【启动服务】"
echo "正在启动 OpenClaw Gateway..."
echo ""

openclaw gateway start

echo ""
echo "================================"
echo -e "${GREEN}✓ 服务已启动${NC}"
echo "================================"
echo ""
echo "访问地址: http://localhost:3000"
echo ""
echo "常用命令:"
echo "  查看状态: openclaw gateway status"
echo "  查看日志: openclaw gateway logs"
echo "  停止服务: openclaw gateway stop"
echo ""