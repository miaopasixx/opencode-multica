FROM node:22-slim
RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*
RUN npm install -g opencode-ai
RUN mkdir -p /root/.config/opencode /root/.local/share/opencode
RUN echo '{"$schema":"https://opencode.ai/config.json","model":"opencode/deepseek-v4-flash-free"}' > /root/.config/opencode/opencode.json
RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash
EXPOSE 10000
CMD export OPENCODE_API_KEY=${OPENCODE_API_KEY} && \
    echo "{\"opencode\":{\"type\":\"api\",\"key\":\"$OPENCODE_API_KEY\"}}" > /root/.local/share/opencode/auth.json && \
    multica config set server_url https://api.multica.ai && \
    multica config set app_url https://multica.ai && \
    echo "$MULTICA_TOKEN" | multica login --token && \
    opencode models --refresh && \
    echo ">>> cache size: $(wc -c < /root/.cache/opencode/models.json)" && \
    multica daemon start && \
    sleep 15 && \
    echo "=== DAEMON LOGS ===" && \
    tail -50 /root/.multica/daemon.log && \
    echo "=== OPENCODE MODEL RAW ===" && \
    opencode models --refresh 2>&1 && \
    multica daemon status && \
    node -e "require('http').createServer((q,r)=>{const c=require('child_process');let o='';try{o=c.execSync('opencode models --refresh 2>&1',{timeout:30000}).toString()}catch(e){o=e.toString()}const m=c.execSync('multica daemon status 2>&1').toString();r.writeHead(200,{'Content-Type':'text/html;charset=utf-8'});r.end('<pre>'+m+'\n--- OpenCode Models ('+o.split('\\n').length+'):\n'+o+'</pre>')}).listen(process.env.PORT||10000)"
