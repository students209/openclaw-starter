#!/bin/bash
# OpenClaw 配置验证工具
# 检查配置文件是否正确

set -e

# 颜色定义
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

CONFIG_FILE="$HOME/.openclaw/openclaw.json"

echo "================================"
echo "  OpenClaw 配置验证工具"
echo "================================"
echo ""

# 检查配置文件是否存在
check_config_file() {
    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${GREEN}✓${NC} 配置文件存在: $CONFIG_FILE"
        return 0
    else
        echo -e "${RED}✗${NC} 配置文件不存在"
        echo ""
        echo "请先运行配置向导或执行: openclaw configure"
        return 1
    fi
}

# 验证 JSON 格式
validate_json() {
    if command -v python3 &> /dev/null; then
        if python3 -c "import json; json.load(open('$CONFIG_FILE'))" 2>/dev/null; then
            echo -e "${GREEN}✓${NC} JSON 格式正确"
            return 0
        else
            echo -e "${RED}✗${NC} JSON 格式错误"
            return 1
        fi
    elif command -v jq &> /dev/null; then
        if jq . "$CONFIG_FILE" > /dev/null 2>&1; then
            echo -e "${GREEN}✓${NC} JSON 格式正确"
            return 0
        else
            echo -e "${RED}✗${NC} JSON 格式错误"
            return 1
        fi
    else
        echo -e "${YELLOW}!${NC} 无法验证 JSON 格式 (需要 python3 或 jq)"
        return 0
    fi
}

# 检查模型配置
check_models() {
    echo ""
    echo "【模型配置检查】"
    
    if command -v jq &> /dev/null; then
        providers=$(jq -r '.models.providers | keys[]' "$CONFIG_FILE" 2>/dev/null || echo "")
        
        if [ -n "$providers" ]; then
            echo -e "${GREEN}✓${NC} 已配置的模型提供商:"
            for p in $providers; do
                has_key=$(jq -r ".models.providers.$p.apiKey // empty" "$CONFIG_FILE" 2>/dev/null)
                if [ -n "$has_key" ]; then
                    echo "  - $p (已配置 API Key)"
                else
                    echo "  - $p ${YELLOW}(未配置 API Key)${NC}"
                fi
            done
        else
            echo -e "${YELLOW}!${NC} 未配置任何模型提供商"
        fi
    else
        echo -e "${YELLOW}!${NC} 需要 jq 工具进行详细检查"
    fi
}

# 检查通道配置
check_channels() {
    echo ""
    echo "【通道配置检查】"
    
    if command -v jq &> /dev/null; then
        channels=$(jq -r '.channels | keys[]' "$CONFIG_FILE" 2>/dev/null || echo "")
        
        if [ -n "$channels" ]; then
            echo -e "${GREEN}✓${NC} 已配置的通道:"
            for c in $channels; do
                enabled=$(jq -r ".channels.$c.enabled // false" "$CONFIG_FILE" 2>/dev/null)
                if [ "$enabled" = "true" ]; then
                    echo "  - $c ${GREEN}(已启用)${NC}"
                else
                    echo "  - $c ${YELLOW}(未启用)${NC}"
                fi
            done
        else
            echo -e "${YELLOW}!${NC} 未配置任何通道"
        fi
    fi
}

# 检查 OpenClaw CLI
check_cli() {
    echo ""
    echo "【CLI 检查】"
    
    if command -v openclaw &> /dev/null; then
        version=$(openclaw --version 2>&1 | head -1 || echo "unknown")
        echo -e "${GREEN}✓${NC} OpenClaw CLI 已安装: $version"
    else
        echo -e "${RED}✗${NC} OpenClaw CLI 未安装"
        echo "  运行: npm install -g openclaw"
    fi
}

# 测试 API 连接
test_api() {
    echo ""
    echo "【API 连接测试】"
    echo -e "${YELLOW}提示: API 测试需要实际调用，可能产生费用${NC}"
    read -p "是否测试 API 连接? (y/n): " -n 1 -r
    echo
    
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if command -v openclaw &> /dev/null; then
            echo "测试中..."
            openclaw config check 2>&1 || echo -e "${YELLOW}API 测试失败，请检查配置${NC}"
        else
            echo -e "${RED}需要 OpenClaw CLI 进行 API 测试${NC}"
        fi
    fi
}

# 主流程
main() {
    check_config_file || exit 1
    validate_json || exit 1
    check_models
    check_channels
    check_cli
    
    echo ""
    echo "================================"
    
    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${GREEN}✓ 配置验证通过${NC}"
        echo ""
        echo "下一步: openclaw gateway start"
    else
        echo -e "${RED}✗ 配置验证未通过${NC}"
        echo ""
        echo "请运行: openclaw configure"
    fi
}

main