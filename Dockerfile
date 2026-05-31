FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

RUN multica config set server_url https://api.multica.ai
RUN multica config set app_url https://multica.ai

EXPOSE 10000

# 用分号替代 &&，确保每步都执行，status 输出到日志
CMD echo "$MULTICA_TOKEN" | multica login --token \
    ; multica daemon start \
    ; sleep 3 \
    ; multica daemon status \
    ; node -e "require('http').createServer((_,r)=>{r.end('ok')}).listen(process.env.PORT||10000)"
