FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

EXPOSE 10000

# 运行时强制配置云端模式，确保不被安装脚本覆盖
CMD multica config set server_url https://api.multica.ai \
    && multica config set app_url https://multica.ai \
    && echo "$MULTICA_TOKEN" | multica login --token \
    && multica daemon start \
    && sleep 3 \
    && multica daemon status \
    ; node -e "require('http').createServer((_,r)=>{r.end('ok')}).listen(process.env.PORT||10000)"
