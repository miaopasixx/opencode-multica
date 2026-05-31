const http = require('http');
const { execSync } = require('child_process');
const PORT = process.env.PORT || 10000;

http.createServer((_q, res) => {
    let daemon = 'N/A', models = 'N/A';
    try { daemon = execSync('multica daemon status 2>&1', {timeout: 5000}).toString().trim(); } catch(e) { daemon = (e.stderr || '').toString() || e.message; }
    try { models = execSync('opencode models 2>&1', {timeout: 12000}).toString().trim(); } catch(e) { models = (e.stderr || '').toString() || e.message; }

    let modelsHtml = '<pre>' + models.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;') + '</pre>';

    const html = `<!DOCTYPE html><html><head><meta charset=utf-8><title>opencode-multica</title><style>body{font-family:monospace;background:#111;color:#0f0;padding:20px}pre{white-space:pre-wrap}h2{border-bottom:1px solid #333;padding-bottom:4px}</style></head><body>
<h2>Multica Daemon</h2><pre>${daemon}</pre>
<h2>OpenCode Models</h2>${modelsHtml}
</body></html>`;
    res.writeHead(200, {'Content-Type':'text/html;charset=utf-8'});
    res.end(html);
}).listen(PORT);
