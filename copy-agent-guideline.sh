#!/usr/bin/env bash

set -euo pipefail

TARGET_FILE="AGENTS.md"
CODEX_GLOBAL_DIR="${CODEX_HOME:-$HOME/.codex}"
SOURCE_FILE="$CODEX_GLOBAL_DIR/agent-guideline.md"

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "오류: 코덱스 글로벌 디렉터리에서 가이드 파일을 찾을 수 없습니다."
  echo "확인 경로: $SOURCE_FILE"
  exit 1
fi

if [[ -f "$TARGET_FILE" ]]; then
  read -r -p "'$TARGET_FILE' 파일이 이미 존재합니다. 덮어쓸까요? [Y/n] " answer
  case "$answer" in
    ""|y|Y|yes|YES|Yes)
      ;;
    *)
      echo "취소: 파일을 덮어쓰지 않았습니다."
      exit 0
      ;;
  esac
fi

cp "$SOURCE_FILE" "$TARGET_FILE"
echo "완료: $SOURCE_FILE -> $(pwd)/$TARGET_FILE"
