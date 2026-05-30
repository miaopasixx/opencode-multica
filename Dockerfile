FROM node:22-slim

RUN apt-get update && apt-get install -y git curl && rm -rf /var/lib/apt/lists/*

# 瀹夎 opencode CLI
RUN npm install -g opencode-ai

# 瀹夎 multica CLI
RUN npm install -g @multica-ai/cli

# 鏆撮湶绔彛
EXPOSE 10000 3000

# 鍚姩 opencode serve (涓荤鍙? + multica daemon (鍚庡彴)
CMD opencode serve --hostname 0.0.0.0 --port 10000
