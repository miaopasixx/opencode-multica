const http = require('http');
const { execSync } = require('child_process');
const PORT = process.env.PORT || 10000;

const MODELS = [
    ['Qwen 3.6 Plus Free',      'qwen3.6-plus-free'],
    ['MiniMax M2.5 Free',       'minimax-m2.5-free'],
    ['MiMo V2.5 Free',          'mimo-v2.5-free'],
    ['DeepSeek V4 Flash Free',  'deepseek-v4-flash-free'],
    ['Nemotron 3 Super Free',   'nemotron-3-super-free'],
];

http.createServer((_q, res) => {
    let daemon = 'N/A', opencodeVer = 'N/A';
    try { daemon = execSync('multica daemon status 2>&1', {timeout: 5000}).toString().trim(); } catch(e) { daemon = (e.stderr || '').toString() || e.message; }
    try { opencodeVer = execSync('opencode --version 2>&1', {timeout: 8000}).toString().trim(); } catch(e) { opencodeVer = '已安装 (cli 响应超时)'; }

    let modelsHtml = '<table border=1 cellpadding=6 cellspacing=0 style=border-collapse:collapse;border-color:#0f0><tr><th>Model</th><th>Model ID</th></tr>';
    for (const [name, id] of MODELS) {
        modelsHtml += `<tr><td>${name}</td><td><code>${id}</code></td></tr>`;
    }
    modelsHtml += '</table>';

    const html = `<!DOCTYPE html><html><head><meta charset=utf-8><title>opencode-multica</title><style>body{font-family:monospace;background:#111;color:#0f0;padding:20px}pre{white-space:pre-wrap}code{color:#ff0}table{color:#0f0}h2{border-bottom:1px solid #333;padding-bottom:4px}a{color:#0ff}</style></head><body>
<h2>Multica Daemon</h2><pre>${daemon}</pre>
<h2>OpenCode</h2><pre>${opencodeVer}</pre>
<h2>Free Models (OpenCode Zen)</h2>${modelsHtml}
</body></html>`;
    res.writeHead(200, {'Content-Type':'text/html;charset=utf-8'});
    res.end(html);
}).listen(PORT);
