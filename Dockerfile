FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

RUN npm install -g opencode-ai

RUN curl -fsSL https://raw.githubusercontent.com/multica-ai/multica/main/scripts/install.sh | bash

EXPOSE 10000

CMD multica config set server_url https://api.multica.ai \
    && multica config set app_url https://multica.ai \
    && echo "$MULTICA_TOKEN" | multica login --token \
    && multica daemon start \
    ; node -e "
        const http = require('http');
        const { execSync } = require('child_process');
        const PORT = process.env.PORT || 10000;
        http.createServer((_q, res) => {
            let status = 'N/A', version = 'N/A';
            try { const s = execSync('multica daemon status 2>&1', {timeout: 5000}).toString(); status = s.trim(); } catch(e) { status = e.stderr?.toString() || e.message; }
            try { version = execSync('opencode --version 2>&1', {timeout: 3000}).toString().trim(); } catch(e) { version = e.message; }
            const html = '<!DOCTYPE html><html><head><meta charset=utf-8><title>opencode-multica</title><style>body{font-family:monospace;background:#111;color:#0f0;padding:20px}pre{white-space:pre-wrap}</style></head><body><h2>Multica Daemon</h2><pre>'+status+'</pre><h2>OpenCode</h2><pre>'+version+'</pre></body></html>';
            res.writeHead(200, {'Content-Type':'text/html;charset=utf-8'});
            res.end(html);
        }).listen(PORT);
    "
