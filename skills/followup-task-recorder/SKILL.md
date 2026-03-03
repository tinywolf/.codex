---
name: followup-task-recorder
description: Follow-up 작업을 요청 묶음(request bundle)으로 등록하고 workstream/task 단위로 분해해 진행 상태를 기록/갱신한다. 사용 시점; 사용자가 후속 작업 파일 작성, 작업 상태 기록, 진행중/완료 갱신, follow-up task 표준화/정리를 요청할 때.
---

# Followup Task Recorder

## Overview

후속 작업은 단일 SPEC/PRD source 없이 다건 요청이 누적될 수 있으므로, 요청 묶음 단위(`workstream`)와 실행 단위(`task`)를 분리해 기록한다.

## Workflow

1. 대상 파일을 확정한다.
- 사용자가 파일 경로를 지정하면 해당 경로를 사용한다.
- 기존 follow-up 파일이 있으면 재사용한다.
- 파일이 없으면 `FOLLOWUP-TASK.md`를 생성한다.

2. 문서 골격을 표준화한다.
- `Summary`: `source`는 `없음 (follow-up 요청 묶음 기반)`으로 기록한다.
- `Split Format`: ID/상태/분리 기준을 고정한다.
- `Request Bundles`: 요청 묶음 목록을 유지한다.
- `Tasks`: bundle 아래에 task를 배치한다.

3. 요청 묶음(workstream)을 생성한다.
- ID 규칙: `FW-<번호>` (예: `FW-02`).
- 이름 규칙: 요청 목적을 한 줄로 요약한다.
- 요청 시각(YYYY-MM-DD)을 함께 기록한다.

4. task를 분해한다.
- ID 규칙: `FW-<번호>-T<번호>`.
- 각 task는 다음 필드를 반드시 가진다.
  - `scope`
  - `dependencies`
  - `progress`
  - `next_action`
- 분리 기준:
  - 영향 범위가 다르면 분리한다.
  - 독립 검증 가능하면 분리한다.
  - 순차 의존이 있으면 dependencies로 명시한다.

5. 상태를 작업 중에 갱신한다.
- 상태 값은 `in_progress`, `done`만 사용한다.
- 구현 시작 전: 관련 task를 `in_progress`로 기록한다.
- 검증 완료 후: `done`으로 전환하고 결과를 `progress`에 남긴다.
- 실패/우회 이력은 `progress`에 원인과 최종 해결을 함께 남긴다.

6. 마감 검증을 수행한다.
- 실행한 테스트/빌드 명령을 `progress`에 남긴다.
- `next_action`은 종료 시 `없음`으로 정리한다.
- 문서가 재개 가능한지(다음 에이전트가 즉시 이어서 가능한지) 확인한다.

## Canonical Format

아래 형식을 기본으로 사용한다.

```markdown
# FOLLOW-UP TASKS

## Summary
- source: 없음 (follow-up 요청 묶음 기반)
- last_updated: YYYY-MM-DD
- open_questions: 없음

## Split Format
- 기준 단위: workstream -> task
- workstream ID: FW-<번호>
- task ID: FW-<번호>-T<번호>
- 상태 값: in_progress, done
- 분리 기준: 영향 범위, 독립 실행 가능성, 검증 가능성

## Request Bundles
- FW-01 | <요청 묶음 제목> (요청 시각: YYYY-MM-DD)

## Tasks
### FW-01 | <요청 묶음 제목>
- [ ] FW-01-T1 | in_progress | <작업명>
  - scope: <범위>
  - dependencies: 없음
  - progress: <현재 진행>
  - next_action: <다음 행동>
```

## Quality Rules

- 이미 완료된 과거 bundle/task는 삭제하지 않는다.
- 상태 변경은 실제 작업 타이밍과 일치시킨다.
- task 이름은 구현 행동 중심으로 작성한다(예: "설정 이관", "회귀 검증").
- 문서 업데이트만 하고 끝내지 말고, 실제 코드/검증 결과와 동기화한다.
