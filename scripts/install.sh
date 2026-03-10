#!/bin/bash
# OpenClaw 一键安装脚本
# 自动安装 OpenClaw CLI 并进行基础配置

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

VERSION="latest"
INSTALL_DIR=""
VERBOSE=false

# 帮助信息
show_help() {
    echo "OpenClaw 安装脚本"
    echo ""
    echo "用法: ./install.sh [选项]"
    echo ""
    echo "选项:"
    echo "  -v, --version <version>  指定安装版本 (默认: latest)"
    echo "  -d, --dir <directory>    指定安装目录"
    echo "  -h, --help               显示帮助信息"
    echo ""
    echo "示例:"
    echo "  ./install.sh                    # 安装最新版本"
    echo "  ./install.sh -v 2026.3.0        # 安装指定版本"
    echo ""
}

# 解析参数
while [[ $# -gt 0 ]]; do
    case $1 in
        -v|--version)
            VERSION="$2"
            shift 2
            ;;
        -d|--dir)
            INSTALL_DIR="$2"
            shift 2
            ;;
        -h|--help)
            show_help
            exit 0
            ;;
        *)
            echo "未知选项: $1"
            show_help
            exit 1
            ;;
    esac
done

echo "================================"
echo "  OpenClaw 一键安装"
echo "================================"
echo ""

# 检测操作系统
OS=$(uname -s)
ARCH=$(uname -m)

echo "【系统检测】"
echo "操作系统: $OS"
echo "架构: $ARCH"
echo ""

# 检测 Node.js
echo "【依赖检测】"
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js 未安装${NC}"
    echo ""
    echo "请先安装 Node.js 18.x 或更高版本："
    echo "  macOS: brew install node"
    echo "  Ubuntu: curl -fsSL https://deb.nodesource.com/setup_20.x | sudo -E bash - && sudo apt install nodejs"
    echo "  Windows: 访问 https://nodejs.org/"
    exit 1
fi

NODE_VERSION=$(node -v)
echo -e "${GREEN}✓ Node.js: $NODE_VERSION${NC}"

if ! command -v npm &> /dev/null; then
    echo -e "${RED}✗ npm 未安装${NC}"
    exit 1
fi
echo -e "${GREEN}✓ npm: $(npm -v)${NC}"

if ! command -v git &> /dev/null; then
    echo -e "${YELLOW}! Git 未安装 (建议安装)${NC}"
else
    echo -e "${GREEN}✓ Git: $(git --version | awk '{print $3}')${NC}"
fi
echo ""

# 检测 npm 镜像
echo "【网络配置】"
NPM_REGISTRY=$(npm config get registry)
echo "当前 npm registry: $NPM_REGISTRY"

if [[ "$NPM_REGISTRY" == *"npmjs.org"* ]]; then
    echo -e "${YELLOW}检测到使用官方源，国内用户建议切换镜像${NC}"
    read -p "是否切换到淘宝镜像? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        npm config set registry https://registry.npmmirror.com
        echo -e "${GREEN}✓ 已切换到淘宝镜像${NC}"
    fi
fi
echo ""

# 安装 OpenClaw
echo "【安装 OpenClaw】"
echo "安装版本: $VERSION"
echo ""

if [ "$VERSION" = "latest" ]; then
    echo "正在安装 openclaw..."
    npm install -g openclaw
else
    echo "正在安装 openclaw@$VERSION..."
    npm install -g openclaw@$VERSION
fi

echo ""
echo "【验证安装】"
if command -v openclaw &> /dev/null; then
    OPENCLAW_VERSION=$(openclaw --version 2>&1 | head -1 || echo "installed")
    echo -e "${GREEN}✓ OpenClaw 安装成功!${NC}"
    echo -e "  版本: ${GREEN}$OPENCLAW_VERSION${NC}"
else
    echo -e "${RED}✗ 安装验证失败${NC}"
    exit 1
fi
echo ""

# 初始化配置
echo "【初始化配置】"
echo "运行 'openclaw' 查看可用命令"
echo "运行 'openclaw configure' 进行初始配置"
echo ""

echo "================================"
echo -e "${GREEN}✓ 安装完成!${NC}"
echo "================================"
echo ""
echo "快速开始："
echo "  1. 初始化项目: openclaw init my-agent"
echo "  2. 进入目录: cd my-agent"
echo "  3. 启动服务: openclaw gateway start"
echo ""
echo "文档: https://docs.openclaw.ai"
echo "社区: https://discord.com/invite/clawd"
echo ""