const http = require('http');
const { execSync } = require('child_process');
const fs = require('fs');
const PORT = process.env.PORT || 10000;

http.createServer((_q, res) => {
    let daemon = 'N/A', models = 'N/A';

    try { daemon = execSync('multica daemon status 2>&1', {timeout: 5000}).toString().trim(); } catch(e) { daemon = (e.stderr || '').toString() || e.message; }

    // 优先读构建时缓存的文件，构建时 opencode 进程可能已被 kill 无法实时运行
    try {
        if (fs.existsSync('/models.txt')) {
            models = fs.readFileSync('/models.txt', 'utf8').trim();
        } else {
            models = 'models cache not found';
        }
    } catch(e) {
        // 回退：尝试实时执行
        try { models = execSync('opencode models 2>&1', {timeout: 15000}).toString().trim(); } catch(e2) { models = (e2.stderr || '').toString() || e2.message; }
    }

    const html = '<!DOCTYPE html><html><head><meta charset=utf-8><title>opencode-multica</title><style>body{font-family:monospace;background:#111;color:#0f0;padding:20px}pre{white-space:pre-wrap}h2{border-bottom:1px solid #333;padding-bottom:4px}</style></head><body><h2>Multica Daemon</h2><pre>'+daemon+'</pre><h2>OpenCode Models</h2><pre>'+models+'</pre></body></html>';
    res.writeHead(200, {'Content-Type':'text/html;charset=utf-8'});
    res.end(html);
}).listen(PORT);
