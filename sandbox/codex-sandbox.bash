#!/usr/bin/env bash

set -euo pipefail

# Optional sandbox-script flags parsed before normal args.
# --mount-skills: mount ~/.codex/skills into container (disabled by default)
MOUNT_SKILLS=false
FILTERED_ARGS=()
while [[ $# -gt 0 ]]; do
  if [[ "$1" == "--" ]]; then
    FILTERED_ARGS+=("$1")
    shift
    FILTERED_ARGS+=("$@")
    break
  elif [[ "$1" == "--mount-skills" ]]; then
    MOUNT_SKILLS=true
    shift
  else
    FILTERED_ARGS+=("$1")
    shift
  fi
done
if ((${#FILTERED_ARGS[@]})); then
  set -- "${FILTERED_ARGS[@]}"
else
  set --
fi

TARGET_DIR="$(pwd)"
if [[ $# -gt 0 && -d "$1" ]]; then
  TARGET_DIR="$(cd "$1" && pwd)"
  shift
fi

if [[ "$TARGET_DIR" == "/" ]]; then
  echo "Refusing to mount host root '/'. Please run from a project directory." >&2
  exit 1
fi

# Optional absolute workdir path inside container.
# Default behavior keeps host absolute path as-is.
CONTAINER_DIR="${CONTAINER_WORKDIR:-$TARGET_DIR}"
if [[ "$CONTAINER_DIR" != /* ]]; then
  echo "CONTAINER_WORKDIR must be an absolute path. Current: '$CONTAINER_DIR'" >&2
  exit 1
fi

# Allow explicit separator before codex args, e.g.:
# bash codex-sandbox.bash /path -- --dangerously-bypass-approvals-and-sandbox
if [[ $# -gt 0 && "$1" == "--" ]]; then
  shift
fi

DOCKER_RUN_CMD=(
  docker run --rm -it
  -v "$TARGET_DIR":"$CONTAINER_DIR"
  -w "$CONTAINER_DIR"
  -v "$HOME/.codex/auth.json":/root/.codex/auth.json:ro
  -v "$HOME/.codex/config.toml":/root/.codex/config.toml:ro
)

if [[ "$MOUNT_SKILLS" == "true" ]]; then
  DOCKER_RUN_CMD+=(
    -v "$HOME/.codex/skills":/root/.codex/skills:ro
  )
fi

if [[ -n "${DOCKER_RUN_OPTS:-}" ]]; then
  # Split DOCKER_RUN_OPTS by whitespace and append to docker run args.
  # Example: DOCKER_RUN_OPTS='--name codex-yolo --network host'
  # shellcheck disable=SC2206
  DOCKER_RUN_EXTRA_ARGS=(${DOCKER_RUN_OPTS})
  DOCKER_RUN_CMD+=("${DOCKER_RUN_EXTRA_ARGS[@]}")
fi

DOCKER_RUN_CMD+=(codex-sandbox "$@")
"${DOCKER_RUN_CMD[@]}"
