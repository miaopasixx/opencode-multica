FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

EXPOSE 10000

# 用 PAT token 免交互登录，启动 multica daemon 连接云端
# opencode serve 作为前台进程保持容器运行
CMD multica login --token $MULTICA_TOKEN && multica daemon start & opencode serve --hostname 0.0.0.0 --port 10000
