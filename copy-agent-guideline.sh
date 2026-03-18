#!/usr/bin/env bash

set -euo pipefail

TARGET_FILE="AGENTS.md"
DEFAULT_INCOMING_FILE="AGENTS.incoming.md"
CODEX_GLOBAL_DIR="${CODEX_HOME:-$HOME/.codex}"
SOURCE_FILE="$CODEX_GLOBAL_DIR/agent-guideline.md"
INCOMING_FILE="$DEFAULT_INCOMING_FILE"
MODE="sync"
AUTO_YES=0

has_command() {
  command -v "$1" >/dev/null 2>&1
}

run_diff() {
  local left_file=$1
  local right_file=$2
  local left_label=$3
  local right_label=$4

  if has_command diff-so-fancy; then
    diff -u --label "$left_label" "$left_file" --label "$right_label" "$right_file" | diff-so-fancy
    return $?
  fi

  diff -u --label "$left_label" "$left_file" --label "$right_label" "$right_file"
}

show_diff_ui() {
  local left_file=$1
  local right_file=$2
  local left_label=$3
  local right_label=$4
  local diff_status=0
  local pager_status=0
  local pipe_status=()

  if [[ -t 1 ]] && has_command less; then
    set +e
    run_diff "$left_file" "$right_file" "$left_label" "$right_label" | less -FRX
    pipe_status=("${PIPESTATUS[@]}")
    set -e

    diff_status=${pipe_status[0]}
    pager_status=${pipe_status[1]:-0}

    if [[ "$pager_status" -ne 0 ]]; then
      return "$pager_status"
    fi

    if [[ "$diff_status" -gt 1 ]]; then
      return "$diff_status"
    fi

    return 0
  fi

  set +e
  run_diff "$left_file" "$right_file" "$left_label" "$right_label"
  diff_status=$?
  set -e

  if [[ "$diff_status" -gt 1 ]]; then
    return "$diff_status"
  fi

  return 0
}

usage() {
  cat <<EOF
사용법: $(basename "$0") [옵션]

기본 동작:
  - AGENTS.md가 없으면 생성합니다.
  - AGENTS.md가 있으면 AGENTS.incoming.md를 생성해 직접 비교할 수 있게 합니다.

옵션:
  --replace           AGENTS.md를 소스 파일로 바로 교체합니다.
  --diff              현재 AGENTS.md와 incoming 가이드의 diff UI를 표시합니다.
  --check             현재 AGENTS.md가 소스 파일과 같은지 검사합니다. 같으면 0, 다르면 2로 종료합니다.
  --incoming <path>   incoming 파일 경로를 지정합니다. 기본값: $DEFAULT_INCOMING_FILE
  --source <path>     소스 가이드 파일 경로를 지정합니다.
  --yes               확인 프롬프트 없이 진행합니다. --replace에서만 사용됩니다.
  --help              도움말을 출력합니다.
EOF
}

set_mode() {
  local next_mode=$1

  if [[ "$MODE" != "sync" ]]; then
    echo "오류: --replace, --diff, --check 중 하나만 사용할 수 있습니다."
    exit 1
  fi

  MODE="$next_mode"
}

while [[ $# -gt 0 ]]; do
  case "$1" in
    --replace)
      set_mode "replace"
      shift
      ;;
    --diff)
      set_mode "diff"
      shift
      ;;
    --check)
      set_mode "check"
      shift
      ;;
    --incoming)
      if [[ $# -lt 2 ]]; then
        echo "오류: --incoming에는 경로가 필요합니다."
        exit 1
      fi
      INCOMING_FILE="$2"
      shift 2
      ;;
    --source)
      if [[ $# -lt 2 ]]; then
        echo "오류: --source에는 경로가 필요합니다."
        exit 1
      fi
      SOURCE_FILE="$2"
      shift 2
      ;;
    --yes)
      AUTO_YES=1
      shift
      ;;
    --help|-h)
      usage
      exit 0
      ;;
    *)
      echo "오류: 알 수 없는 옵션입니다: $1"
      echo
      usage
      exit 1
      ;;
  esac
done

if [[ ! -f "$SOURCE_FILE" ]]; then
  echo "오류: 코덱스 글로벌 디렉터리에서 가이드 파일을 찾을 수 없습니다."
  echo "확인 경로: $SOURCE_FILE"
  exit 1
fi

if [[ "$INCOMING_FILE" == "$TARGET_FILE" ]]; then
  echo "오류: incoming 파일 경로는 '$TARGET_FILE'과 같을 수 없습니다."
  exit 1
fi

if [[ -e "$INCOMING_FILE" && ! -f "$INCOMING_FILE" ]]; then
  echo "오류: incoming 경로가 일반 파일이 아닙니다: $INCOMING_FILE"
  exit 1
fi

if [[ -e "$TARGET_FILE" && ! -f "$TARGET_FILE" ]]; then
  echo "오류: 대상 경로가 일반 파일이 아닙니다: $TARGET_FILE"
  exit 1
fi

case "$MODE" in
  check)
    if [[ ! -f "$TARGET_FILE" ]]; then
      echo "검사 결과: $TARGET_FILE 파일이 없습니다."
      exit 2
    fi

    if cmp -s "$SOURCE_FILE" "$TARGET_FILE"; then
      echo "검사 결과: $TARGET_FILE 파일이 글로벌 가이드와 동일합니다."
      exit 0
    fi

    echo "검사 결과: $TARGET_FILE 파일에 검토할 차이가 있습니다."
    exit 2
    ;;
  diff)
    if [[ ! -f "$TARGET_FILE" ]]; then
      show_diff_ui /dev/null "$SOURCE_FILE" "$TARGET_FILE" "$INCOMING_FILE"
      exit 0
    fi

    show_diff_ui "$TARGET_FILE" "$SOURCE_FILE" "$TARGET_FILE" "$INCOMING_FILE"
    exit 0
    ;;
  replace)
    if [[ -f "$TARGET_FILE" && "$AUTO_YES" -ne 1 ]]; then
      read -r -p "'$TARGET_FILE' 파일을 소스 가이드로 교체할까요? [Y/n] " answer
      case "$answer" in
        ""|y|Y|yes|YES|Yes)
          ;;
        *)
          echo "취소: 파일을 교체하지 않았습니다."
          exit 0
          ;;
      esac
    fi

    cp "$SOURCE_FILE" "$TARGET_FILE"
    echo "완료: $TARGET_FILE 파일을 소스 가이드로 교체했습니다."
    echo "소스: $SOURCE_FILE"
    echo "대상: $(pwd)/$TARGET_FILE"
    exit 0
    ;;
esac

if [[ ! -f "$TARGET_FILE" ]]; then
  cp "$SOURCE_FILE" "$TARGET_FILE"
  echo "완료: $TARGET_FILE 파일을 생성했습니다."
  echo "소스: $SOURCE_FILE"
  echo "대상: $(pwd)/$TARGET_FILE"
  exit 0
fi

if cmp -s "$SOURCE_FILE" "$TARGET_FILE"; then
  echo "변경 사항 없음: $TARGET_FILE 파일이 글로벌 가이드와 동일합니다."
  exit 0
fi

cp "$SOURCE_FILE" "$INCOMING_FILE"
echo "기존 $TARGET_FILE 파일은 유지했습니다."
echo "새 글로벌 가이드를 $INCOMING_FILE 파일로 저장했습니다."
show_diff_ui "$TARGET_FILE" "$INCOMING_FILE" "$TARGET_FILE" "$INCOMING_FILE"
echo
echo "검토 후 필요한 내용만 $TARGET_FILE 파일에 반영하세요."
echo "권장: $INCOMING_FILE 파일은 .gitignore에 추가해 두는 편이 좋습니다."
