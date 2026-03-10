# OpenClaw 入门助手

一键安装，轻松上手 AI Agent 开发

## 快速开始

### 方式一：npm 安装（推荐）

```bash
npm install -g openclaw
```

### 方式二：安装脚本

```bash
curl -fsSL https://openclaw.ai/install.sh | bash
```

## 环境要求

| 依赖 | 版本要求 | 说明 |
|------|----------|------|
| Node.js | >= 18.x | 必需 |
| npm | >= 9.x | 必需 |
| Git | 任意版本 | 建议 |
| Docker | 任意版本 | 可选 |

## 安装步骤

### 1. 环境检测

```bash
# 下载并运行检测脚本
curl -fsSL https://raw.githubusercontent.com/students209/openclaw-starter/main/scripts/check-env.sh | bash
```

### 2. 安装 OpenClaw

```bash
npm install -g openclaw
```

### 3. 初始化项目

```bash
openclaw init my-agent
cd my-agent
```

### 4. 配置并启动

```bash
# 配置 API Key
openclaw configure

# 启动 Gateway 服务
openclaw gateway start
```

## 常见问题

### Q: Node.js 版本过低怎么办？

建议升级到 Node.js 18.x 或更高版本。可以使用 nvm 管理 Node 版本：

```bash
# 安装 nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# 安装 Node.js 20
nvm install 20
nvm use 20
```

### Q: npm 安装速度慢怎么办？

国内用户建议使用淘宝镜像：

```bash
npm config set registry https://registry.npmmirror.com
```

### Q: 没有 API Key 怎么办？

OpenClaw 支持多种 AI 提供商：

- [OpenAI](https://platform.openai.com/)
- [Anthropic Claude](https://console.anthropic.com/)
- [阿里云通义千问](https://dashscope.aliyun.com/)
- [Moonshot Kimi](https://platform.moonshot.cn/)

### Q: 如何在微信/Telegram 上使用？

OpenClaw 支持多通道部署：

1. 运行 `openclaw configure`
2. 选择对应的通道类型
3. 按提示配置 Token 等信息

## 项目结构

```
openclaw-starter/
├── scripts/
│   ├── check-env.sh    # 环境检测脚本
│   └── install.sh      # 一键安装脚本
├── web/
│   └── index.html      # Web 引导页面
├── docs/
│   └── faq.md          # 常见问题文档
└── README.md
```

## 相关链接

- 📖 [官方文档](https://docs.openclaw.ai)
- 💻 [GitHub](https://github.com/openclaw/openclaw)
- 💬 [Discord 社区](https://discord.com/invite/clawd)
- 📦 [npm 包](https://www.npmjs.com/package/openclaw)

## License

MIT