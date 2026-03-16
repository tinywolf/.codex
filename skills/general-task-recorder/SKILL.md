---
name: general-task-recorder
description: 사용자가 `general-task-recorder` 스킬 실행을 명시적으로 요청했을 때만 사용한다. 그 경우 SPEC/PRD가 없는 요청 기반 후속 작업, 운영성 개선, 비정형 planning을 기록/갱신하고 request bundle 또는 단일 task 목록으로 상태 추적을 남긴다. SPEC 기반 구현 범위 도출이나 정식 구현 계획 수립은 spec-task-recorder를 사용한다.
---

# General Task Recorder

## Overview

이 스킬은 사용자가 `general-task-recorder` 스킬 실행을 명시적으로 요청했을 때만 사용한다. 그 경우 단일 `SPEC.md` 없이 들어온 후속 요청, 운영성 작업, ad hoc planning을 재개 가능한 task 문서로 정리한다.

- 요청이 여러 갈래로 누적되면 `workstream -> task` 구조를 사용한다.
- 단일 작업 흐름이면 flat한 task 목록을 사용해도 된다.
- 명확한 `SPEC.md`를 기준으로 구현 범위를 도출하는 작업 계획이면 `spec-task-recorder`를 사용한다.

## Workflow

1. 대상 파일을 확정한다.
- 사용자가 파일 경로를 지정하면 해당 경로를 사용한다.
- 기존 task tracking 파일이 있으면 재사용한다.
- 파일이 없으면 `GENERAL-TASKS.md`를 생성한다.

2. 입력 source와 스킬 적용 가능성을 분류한다.
- 사용자가 `general-task-recorder` 스킬 실행을 명시적으로 요청하지 않았다면 이 스킬을 적용하지 않는다.
- `SPEC.md`가 계획의 기준 source이고 구현 범위를 스펙에서 도출해야 하면 이 스킬을 쓰지 말고 `spec-task-recorder`를 사용한다.
- source가 후속 요청 묶음, 운영 이슈, freeform planning 메모라면 이 스킬을 사용한다.
- `Summary.source`에는 실제 출처를 적는다.
  - 예: `없음 (요청 기반)`, `팀 요청 메모`, `이슈 코멘트 모음`

3. 문서 구조를 선택한다.
- 여러 요청 묶음이나 병렬 workstream이 있으면 `workstream -> task` 구조를 사용한다.
- 단일 planning 흐름이면 `Tasks` 섹션에 바로 task를 기록한다.
- `Split Format`에는 선택한 구조, ID 규칙, 상태 값을 명시한다.

4. 필요하면 요청 묶음(workstream)을 생성한다.
- ID 규칙: `FW-<번호>` (예: `FW-02`).
- 이름 규칙: 요청 목적을 한 줄로 요약한다.
- 요청 시각(YYYY-MM-DD)을 함께 기록한다.

5. task를 분해한다.
- ID 규칙:
  - workstream 구조: `FW-<번호>-T<번호>`
  - flat 구조: `T<번호>`
- 각 task는 다음 필드를 반드시 가진다.
  - `scope`
  - `dependencies`
  - `progress`
  - `next_action`
- 분리 기준:
  - 영향 범위가 다르면 분리한다.
  - 독립 검증 가능하면 분리한다.
  - 순차 의존이 있으면 dependencies로 명시한다.

6. 상태를 작업 중에 갱신한다.
- 상태 값은 `not_started`, `in_progress`, `blocked`, `done`만 사용한다.
- `not_started`: 작업이 식별되었지만 실제 착수 전이다.
- `in_progress`: 구현, 조사, 검증 중이다.
- `blocked`: 외부 결정, 선행 작업, 장애로 진행할 수 없다. 원인과 unblock 행동을 `progress`, `next_action`에 남긴다.
- `done`: 필요한 구현과 검증이 끝난 상태다. 검증 전이면 `done`으로 바꾸지 않는다.
- 실패/우회 이력은 `progress`에 원인과 최종 해결을 함께 남긴다.

7. 마감 검증을 수행한다.
- 실행한 테스트/빌드 명령을 `progress`에 남긴다.
- `next_action`은 종료 시 `없음`으로 정리한다.
- 문서가 재개 가능한지(다음 에이전트가 즉시 이어서 가능한지) 확인한다.

## Canonical Format

아래 형식을 기본으로 사용한다.

```markdown
# GENERAL TASKS

## Summary
- source: <실제 입력 source>
- last_updated: YYYY-MM-DD
- open_questions: 없음

## Split Format
- 구조: workstream -> task | flat task list
- workstream ID: FW-<번호> (workstream 구조일 때)
- task ID: FW-<번호>-T<번호> | T<번호>
- 상태 값: not_started, in_progress, blocked, done
- 분리 기준: 영향 범위, 독립 실행 가능성, 검증 가능성

## Request Bundles
- FW-01 | <요청 묶음 제목> (요청 시각: YYYY-MM-DD)

## Tasks
### FW-01 | <요청 묶음 제목>
- [ ] FW-01-T1 | not_started | <작업명>
  - scope: <범위>
  - dependencies: 없음
  - progress: 아직 시작하지 않음
  - next_action: <다음 행동>
- [ ] FW-01-T2 | blocked | <작업명>
  - scope: <범위>
  - dependencies: FW-01-T1
  - progress: 외부 결정 대기 중
  - next_action: 결정권자 확인 후 재개
```

단일 planning 흐름이면 아래처럼 flat 구조를 사용해도 된다.

```markdown
# GENERAL TASKS

## Summary
- source: 없음 (freeform planning)
- last_updated: YYYY-MM-DD
- open_questions: 없음

## Split Format
- 구조: flat task list
- task ID: T<번호>
- 상태 값: not_started, in_progress, blocked, done
- 분리 기준: 영향 범위, 독립 실행 가능성, 검증 가능성

## Tasks
- [ ] T1 | not_started | <작업명>
  - scope: <범위>
  - dependencies: 없음
  - progress: 아직 시작하지 않음
  - next_action: <다음 행동>
```

## Quality Rules

- 이미 완료된 과거 bundle/task는 삭제하지 않는다.
- 상태 변경은 실제 작업 타이밍과 일치시킨다.
- task 이름은 구현 행동 중심으로 작성한다(예: "설정 이관", "회귀 검증").
- 일반 planning에 쓰더라도 `SPEC.md`가 기준 source인 정식 구현 계획 수립을 대신하지 않는다.
- `blocked` task는 막힌 이유와 재개 조건이 문서만 봐도 드러나야 한다.
- 문서 업데이트만 하고 끝내지 말고, 실제 코드/검증 결과와 동기화한다.
