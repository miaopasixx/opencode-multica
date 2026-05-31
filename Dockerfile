FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# 安装 opencode CLI
RUN npm install -g opencode-ai

# 验证 opencode 在 PATH 中
RUN which opencode && opencode --version

# 安装 multica CLI
RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

# 配置 multica 连接云端
RUN multica config set server_url https://api.multica.ai
RUN multica config set app_url https://multica.ai

EXPOSE 10000

# 1. token 登录 multica
# 2. 启动 daemon（后台），扫描 PATH 发现 opencode 并注册
# 3. 轻量 HTTP 保活
CMD echo "$MULTICA_TOKEN" | multica login --token \
    && echo "=== daemon starting ===" \
    && multica daemon start \
    && sleep 5 \
    && multica daemon status \
    & node -e "require('http').createServer((_,r)=>{r.end('ok')}).listen(process.env.PORT||10000)"
