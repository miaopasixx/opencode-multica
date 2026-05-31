FROM node:22-slim
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g opencode-ai
RUN mkdir -p /root/.config/opencode
RUN echo '{"$schema":"https://opencode.ai/config.json","model":"opencode/deepseek-v4-flash-free"}' > /root/.config/opencode/opencode.json
RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash
COPY status.js /status.js
EXPOSE 10000
CMD export OPENCODE_API_KEY=${OPENCODE_API_KEY} && \
    multica config set server_url https://api.multica.ai && \
    multica config set app_url https://multica.ai && \
    echo "$MULTICA_TOKEN" | multica login --token && \
    echo ">>> opencode models: $(opencode models 2>&1 | wc -l)" && \
    opencode models --refresh 2>&1 | tail -1 && \
    echo ">>> cache: $(ls -lh /root/.cache/opencode/models.json 2>&1)" && \
    multica daemon start && \
    sleep 10 && \
    multica daemon status && \
    node /status.js
