FROM node:22-slim
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g opencode-ai
RUN mkdir -p /root/.config/opencode
# 去掉 provider.zen 空壳，让 opencode 从环境变量读取 OPENCODE_API_KEY
RUN echo '{"$schema":"https://opencode.ai/config.json","model":"opencode/deepseek-v4-flash-free"}' > /root/.config/opencode/opencode.json
RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash
COPY status.js /status.js
EXPOSE 10000
CMD export OPENCODE_API_KEY=${OPENCODE_API_KEY} && \
    multica config set server_url https://api.multica.ai && \
    multica config set app_url https://multica.ai && \
    echo "$MULTICA_TOKEN" | multica login --token && \
    echo ">>> opencode models count: $(opencode models 2>&1 | wc -l)" && \
    multica daemon start && \
    sleep 5 && \
    multica daemon status && \
    node /status.js
