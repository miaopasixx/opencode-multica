FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# 安装 opencode CLI（daemon 扫描 PATH 发现即可，不需要 serve 模式）
RUN npm install -g opencode-ai

# 安装 multica CLI
RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

# 配置 multica 连接云端
RUN multica config set server_url https://api.multica.ai
RUN multica config set app_url https://multica.ai

EXPOSE 10000

# daemon 连云端注册 opencode；轻量 HTTP 仅保活（Render 要求端口绑定）
CMD echo "$MULTICA_TOKEN" | multica login --token \
    && multica daemon start \
    & node -e "require('http').createServer((_,r)=>{r.end('ok')}).listen(process.env.PORT||10000)"
