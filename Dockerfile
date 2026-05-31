FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

# 配置 multica 连接云端
RUN multica config set server_url https://api.multica.ai
RUN multica config set app_url https://multica.ai

EXPOSE 10000

# 用 pipe 传 PAT token 免交互登录，启动 multica daemon，opencode 前台保活
CMD echo "$MULTICA_TOKEN" | multica login --token && multica daemon start & opencode serve --hostname 0.0.0.0 --port 10000
