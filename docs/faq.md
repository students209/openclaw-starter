# OpenClaw 常见问题 (FAQ)

## 安装相关

### Q: 支持哪些操作系统？

OpenClaw 支持以下操作系统：
- macOS 10.15+
- Windows 10/11 (WSL2 推荐)
- Ubuntu 18.04+
- 其他 Linux 发行版

### Q: 安装时报权限错误怎么办？

**macOS/Linux:**
```bash
sudo npm install -g openclaw
```

或者使用 nvm 管理 Node.js，避免权限问题。

**Windows:**
以管理员身份运行 PowerShell。

### Q: 安装后找不到 openclaw 命令？

1. 确认 npm 全局安装路径在 PATH 中：
```bash
npm config get prefix
```

2. 添加到 PATH（macOS/Linux）：
```bash
echo 'export PATH="$(npm config get prefix)/bin:$PATH"' >> ~/.zshrc
source ~/.zshrc
```

## 配置相关

### Q: 如何配置 API Key？

运行配置向导：
```bash
openclaw configure
```

或手动编辑配置文件：
```bash
# macOS/Linux
~/.openclaw/openclaw.json

# Windows
%USERPROFILE%\.openclaw\openclaw.json
```

### Q: 支持哪些 AI 模型？

OpenClaw 支持多种 AI 提供商：

| 提供商 | 模型示例 | 获取方式 |
|--------|----------|----------|
| OpenAI | GPT-4, GPT-3.5 | [platform.openai.com](https://platform.openai.com/) |
| Anthropic | Claude 3 | [console.anthropic.com](https://console.anthropic.com/) |
| 阿里云 | 通义千问 | [dashscope.aliyun.com](https://dashscope.aliyun.com/) |
| Moonshot | Kimi | [platform.moonshot.cn](https://platform.moonshot.cn/) |
| Google | Gemini | [ai.google.dev](https://ai.google.dev/) |
| 本地模型 | Ollama | [ollama.ai](https://ollama.ai/) |

### Q: 如何使用本地模型？

1. 安装 Ollama
2. 拉取模型：`ollama pull llama2`
3. 在 OpenClaw 配置中添加 Ollama 提供商

## 通道相关

### Q: 如何配置微信？

1. 获取企业微信应用的 CorpId、AgentId、Secret
2. 运行 `openclaw configure`
3. 选择 "企业微信" 通道
4. 填入配置信息

### Q: 如何配置 Telegram？

1. 与 @BotFather 对话创建 Bot
2. 获取 Bot Token
3. 运行 `openclaw configure`
4. 选择 "Telegram" 通道
5. 填入 Token

### Q: 如何配置 Discord？

1. 在 Discord Developer Portal 创建应用
2. 创建 Bot 并获取 Token
3. 邀请 Bot 到服务器
4. 运行 `openclaw configure`
5. 选择 "Discord" 通道

## 运行相关

### Q: 如何启动服务？

```bash
# 启动 Gateway 服务
openclaw gateway start

# 查看状态
openclaw gateway status

# 停止服务
openclaw gateway stop
```

### Q: 如何查看日志？

```bash
# 查看实时日志
openclaw gateway logs -f

# 日志文件位置
~/.openclaw/logs/
```

### Q: 端口被占用怎么办？

修改配置文件中的端口：
```json
{
  "gateway": {
    "port": 3001
  }
}
```

或使用环境变量：
```bash
OPENCLAW_PORT=3001 openclaw gateway start
```

## 技能相关

### Q: 如何安装技能？

从 ClawHub 安装：
```bash
openclaw skill install <skill-name>
```

本地安装：
将技能文件夹放到 `~/.agents/skills/` 目录

### Q: 如何创建自己的技能？

1. 创建技能目录
2. 编写 SKILL.md 文件
3. 定义工具和提示词

详见：[技能开发文档](https://docs.openclaw.ai/skills)

## 故障排除

### Q: 响应很慢怎么办？

可能原因：
1. 网络问题 - 使用代理或切换镜像
2. 模型响应慢 - 切换更快的模型
3. 上下文太长 - 清理历史消息

### Q: 出现未知错误？

1. 查看日志：`openclaw gateway logs`
2. 检查配置：`openclaw config check`
3. 更新版本：`npm update -g openclaw`
4. 提交 Issue：[GitHub Issues](https://github.com/openclaw/openclaw/issues)

---

更多问题？加入 [Discord 社区](https://discord.com/invite/clawd) 获取帮助！