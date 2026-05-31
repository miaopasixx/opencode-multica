const http = require('http');
const { execSync } = require('child_process');
const PORT = process.env.PORT || 10000;

http.createServer((_q, res) => {
    let daemon = 'N/A', opencode = 'N/A';
    try { daemon = execSync('multica daemon status 2>&1', {timeout: 5000}).toString().trim(); } catch(e) { daemon = (e.stderr || '').toString() || e.message; }
    try { opencode = execSync('opencode --version 2>&1', {timeout: 3000}).toString().trim(); } catch(e) { opencode = e.message; }
    const html = '<!DOCTYPE html><html><head><meta charset=utf-8><title>opencode-multica</title><style>body{font-family:monospace;background:#111;color:#0f0;padding:20px}pre{white-space:pre-wrap}</style></head><body><h2>Multica Daemon</h2><pre>'+daemon+'</pre><h2>OpenCode</h2><pre>'+opencode+'</pre></body></html>';
    res.writeHead(200, {'Content-Type':'text/html;charset=utf-8'});
    res.end(html);
}).listen(PORT);
