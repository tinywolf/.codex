## Codex 샌드박스

### Docker 빌드
```bash
docker build -t codex-sandbox -f codex-sandbox.Dockerfile .
```

### 샌드박스 실행
```bash
bash codex-sandbox.bash
```

### 특정 디렉토리로 실행
```bash
bash codex-sandbox.bash /path/to/project
```

### 컨테이너 내부 절대 경로로 마운트
호스트 경로와 컨테이너 경로를 다르게 쓰려면 `CONTAINER_WORKDIR`를 지정한다.

```bash
CONTAINER_WORKDIR=/workspace/project \
bash codex-sandbox.bash /path/to/project
```

### codex 인자 전달
`--` 뒤에 전달한 인자는 그대로 codex 명령어에 전달한다.

```bash
bash codex-sandbox.bash /path/to/project -- \
  --dangerously-bypass-approvals-and-sandbox
```

### docker run 런타임 인자 전달
Docker 런타임 인자는 `DOCKER_RUN_OPTS` 환경변수로 전달한다.

```bash
DOCKER_RUN_OPTS='--name codex-yolo --network host' \
bash codex-sandbox.bash /path/to/project -- \
  --dangerously-bypass-approvals-and-sandbox
```
