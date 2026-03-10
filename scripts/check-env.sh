#!/bin/bash
# OpenClaw 环境检测脚本
# 检测系统环境是否满足 OpenClaw 安装要求

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo "================================"
echo "  OpenClaw 环境检测工具"
echo "================================"
echo ""

# 检测结果
PASS=0
FAIL=0
WARN=0

check_command() {
    local cmd=$1
    local name=$2
    local required=$3
    local min_version=$4
    
    if command -v $cmd &> /dev/null; then
        version=$($cmd --version 2>&1 | head -1 || echo "unknown")
        echo -e "${GREEN}✓${NC} $name: 已安装 ($version)"
        ((PASS++))
        return 0
    else
        if [ "$required" = "required" ]; then
            echo -e "${RED}✗${NC} $name: 未安装 (必需)"
            ((FAIL++))
        else
            echo -e "${YELLOW}!${NC} $name: 未安装 (可选)"
            ((WARN++))
        fi
        return 1
    fi
}

echo "【系统信息】"
echo "操作系统: $(uname -s)"
echo "系统版本: $(uname -r)"
echo "架构: $(uname -m)"
echo ""

echo "【必需依赖检测】"
check_command "node" "Node.js" "required"
check_command "npm" "npm" "required"
check_command "git" "Git" "required"
echo ""

echo "【可选依赖检测】"
check_command "docker" "Docker" "optional"
check_command "pnpm" "pnpm" "optional"
check_command "yarn" "Yarn" "optional"
echo ""

echo "【Node.js 版本检测】"
if command -v node &> /dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//')
    NODE_MAJOR=$(echo $NODE_VERSION | cut -d. -f1)
    
    if [ "$NODE_MAJOR" -ge 18 ]; then
        echo -e "${GREEN}✓${NC} Node.js 版本符合要求 (>= 18.x)"
    else
        echo -e "${RED}✗${NC} Node.js 版本过低，建议升级到 18.x 或更高"
        ((FAIL++))
    fi
fi
echo ""

echo "【网络检测】"
echo -n "检测 npm registry... "
if curl -s --connect-timeout 5 https://registry.npmjs.org > /dev/null; then
    echo -e "${GREEN}可访问${NC}"
else
    echo -e "${YELLOW}访问较慢，建议配置国内镜像${NC}"
    echo "  运行: npm config set registry https://registry.npmmirror.com"
fi

echo -n "检测 GitHub... "
if curl -s --connect-timeout 5 https://github.com > /dev/null; then
    echo -e "${GREEN}可访问${NC}"
else
    echo -e "${RED}无法访问${NC}"
fi
echo ""

echo "================================"
echo "【检测结果汇总】"
echo -e "${GREEN}通过: $PASS${NC}"
echo -e "${RED}失败: $FAIL${NC}"
echo -e "${YELLOW}警告: $WARN${NC}"
echo ""

if [ $FAIL -eq 0 ]; then
    echo -e "${GREEN}✓ 环境检测通过，可以安装 OpenClaw${NC}"
    echo ""
    echo "下一步：运行安装脚本"
    echo "  curl -fsSL https://openclaw.ai/install.sh | bash"
    echo "  或"
    echo "  npm install -g openclaw"
    exit 0
else
    echo -e "${RED}✗ 环境检测未通过，请先安装缺失的依赖${NC}"
    echo ""
    echo "安装建议："
    [ ! -x "$(command -v node)" ] && echo "  Node.js: https://nodejs.org/"
    [ ! -x "$(command -v git)" ] && echo "  Git: https://git-scm.com/"
    exit 1
fi