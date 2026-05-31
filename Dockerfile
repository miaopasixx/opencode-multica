FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

COPY status.js /status.js

EXPOSE 10000

CMD multica config set server_url https://api.multica.ai && multica config set app_url https://multica.ai && echo "$MULTICA_TOKEN" | multica login --token && multica daemon start ; node /status.js
