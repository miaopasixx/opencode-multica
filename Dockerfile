FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

# 构建阶段预执行 opencode models 缓存模型列表
RUN timeout 30 opencode models 2>&1 > /models.txt || echo "models command timeout" > /models.txt

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

COPY status.js /status.js

EXPOSE 10000

CMD multica config set server_url https://api.multica.ai && multica config set app_url https://multica.ai && echo "$MULTICA_TOKEN" | multica login --token && multica daemon start ; node /status.js
