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
    opencode models --refresh 2>&1 | head -5 && \
    multica daemon start && \
    node -e "const h=require('http'),c=require('child_process');h.createServer((q,r)=>{r.writeHead(200,{'Content-Type':'text/html;charset=utf-8'});let o='';try{o=c.execSync('opencode models 2>&1',{timeout:15000,env:{...process.env,OPENCODE_API_KEY:process.env.OPENCODE_API_KEY}}).toString()}catch(e){o=e.toString()}r.end('<pre>'+c.execSync('multica daemon status 2>&1').toString()+'--- OpenCode ('+o.split(/\\r?\\n/).filter(Boolean).length+'): '+o.substring(0,500)+'</pre>')}).listen(process.env.PORT||10000)"
