---
name: spec-task-recorder
description: SPEC.md(필수)와 PRD.md(선택)를 분석해 구현 작업을 세부 TASK로 분해하고 진행 상태를 포함한 TASK.md로 기록·갱신한다. 스펙 기반 작업 계획 수립, 작업 분해, 재개 가능한 진행상태 기록이 필요할 때 사용한다. 사용 예; "작업 계획 수립", "작업 계획 파일 작성", "TASK.md 작성".
---

# Spec/Task Recorder

## 목표
- SPEC.md를 우선 분석해 필요한 구현 작업을 도출한다.
- 필요할 때만 PRD.md를 참고해 누락/충돌/해석을 보완한다.
- 작업 중단 후 재개가 가능하도록 TASK.md에 진행 상태를 기록한다.

## 작업 절차
1. `SPEC.md`를 읽고 구현에 필요한 작업 목록을 도출한다.
2. SPEC만으로 불명확하거나 충돌이 의심되면 `PRD.md`를 추가로 읽어 확인한다.
3. 작업량이 크거나 복잡한 경우에만 하위 TASK로 분해한다.
   - 분해 기준: 다른 작업과 최대한 독립적으로 수행 가능하고 독립적으로 책임질 수 있는 단위
   - 굳이 나눌 필요가 없으면 나누지 않는다.
4. `TASK.md`를 새로 만들거나 기존 파일을 갱신한다.
   - 기존 TASK가 있으면 완료/진행 상태를 보존하고, SPEC 변경에 맞춰 추가/수정/삭제를 명시한다.
5. 작업 상태는 재개 가능한 수준으로 기록한다(다음 행동이 바로 이어질 수 있게).

## TASK.md 포맷
- 상단에 요약 블록을 둔다.
- 각 TASK는 고유 ID와 상태를 가진다.
- 상태 값: `not_started`, `in_progress`, `blocked`, `done` 중 하나.

### 예시 포맷

```markdown
# TASKS

## Summary
- source: SPEC.md (+ PRD.md if used)
- last_updated: YYYY-MM-DD
- open_questions: (있으면 간단히)

## Tasks
- [ ] T1 | not_started | 사용자 인증 플로우 구현
  - scope: 로그인/로그아웃, 세션 유지
  - dependencies: 없음
  - next_action: 인증 API 스펙 확정

- [ ] T2 | in_progress | 데이터 마이그레이션 스크립트
  - scope: legacy -> new schema
  - dependencies: T1
  - next_action: 마이그레이션 대상 테이블 목록 확정

- [x] T3 | done | 환경 변수 정리
  - scope: .env 템플릿 업데이트
  - dependencies: 없음
  - notes: PR #123 반영
```

## 유의사항
- 추측이 필요한 부분은 `open_questions`에 기록하고, TASK의 `next_action`에 확인 작업을 명시한다.
- 상태는 실제 진행 상황에 맞게 업데이트한다. 막힌 경우 `blocked`로 바꾸고 원인을 적는다.
- TASK는 중복 없이, SPEC의 구현 단위를 빠짐없이 커버한다.
