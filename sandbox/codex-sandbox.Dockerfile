# Codex 런타임 (단일 Dockerfile)
FROM node:20-slim

# 필수 유틸 (git 등은 프로젝트에 따라 필요할 수 있음)
RUN apt-get update && apt-get install -y --no-install-recommends \
    git ca-certificates ripgrep jq curl unzip zip procps less fd-find \
 && rm -rf /var/lib/apt/lists/*

# Codex CLI 설치
RUN npm install -g @openai/codex

WORKDIR /workspace

# 기본 엔트리포인트를 codex로
ENTRYPOINT ["codex"]
