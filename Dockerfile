FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

# 创建 opencode 配置目录和文件，使无头环境下也能工作
RUN mkdir -p /root/.config/opencode
RUN echo '{"$schema":"https://opencode.ai/config.json","model":"opencode/deepseek-v4-flash-free","small_model":"opencode/qwen3.6-plus-free","provider":{"zen":{}}}' > /root/.config/opencode/opencode.json

# 构建阶段预执行，确保 opencode 可正常运行
RUN timeout 30 opencode models 2>&1 > /models.txt || echo "TIMEOUT" > /models.txt

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

COPY status.js /status.js

EXPOSE 10000

CMD multica config set server_url https://api.multica.ai && multica config set app_url https://multica.ai && echo "$MULTICA_TOKEN" | multica login --token && multica daemon start ; node /status.js
