---
name: agent-guideline-writer
description: 현재 workspace의 codebase를 분석해 AGENTS_GUIDELINE.md 형태의 에이전트 동작 지침서를 작성하거나 갱신한다. 프로젝트 설명, setup & build 지침, 코드 스타일/가이드라인, 테스트, Boundaries를 포함한 가이드를 만들 때 사용한다. 사용 예; "agent.md 작성해", "에이전트 가이드라인 작성".
---

# 에이전트 지침서 작성

## 작업 흐름

1) 대상 파일 결정
- 사용자가 파일명을 명시하면 그대로 사용한다.
- 이미 `AGENTS_GUIDELINE.md`가 있으면 갱신한다.
- 둘 다 없고 사용자가 명시하지 않았다면 기본으로 `AGENTS_GUIDELINE.md`를 생성한다.

2) codebase 상태 확인
- codebase가 비어 있으면(의미 있는 파일이 거의 없으면) 필수 정보를 질문한다.
- codebase에 구현물이 있으면 파일 구조와 설정 파일을 기반으로 내용을 분석한다.

3) 핵심 정보 수집(비어있을 때 질문)
- 프로젝트 목적/도메인, 주요 기능 요약
- 사용 언어/프레임워크/빌드 도구
- setup & build 절차(필요 환경, 설치 명령, 실행 명령)
- 코드 스타일/가이드라인(포매터, 린터, 네이밍 규칙)
- 테스트 실행 방법과 범위
- Boundaries(금지 작업, 민감 데이터 처리, 배포/운영 제한 등)

4) 분석 기준(구현물이 있을 때)
- `README.*`, `package.json`, `pyproject.toml`, `go.mod`, `pom.xml`, `build.gradle*`, `Cargo.toml` 등에서 빌드/실행/테스트 정보를 추출한다.
- `*.editorconfig`, `eslint*`, `prettier*`, `ruff*`, `flake8*`, `golangci*`, `rustfmt*` 등에서 스타일 규칙을 요약한다.
- CI 설정(`.github/workflows/*`, `buildkite`, `circleci`, `gitlab-ci.yml`)에서 테스트와 품질 게이트를 확인한다.

5) 지침서 작성
- `assets/agent-guideline-template.md` 템플릿을 기반으로 필요한 정보를 채운다.
- `assets/agents-template.md` 템플릿을 사용해 `AGENTS.md`도 함께 생성한다.
- 특정 벤더/제품/모델에 종속되지 않도록 일반화된 표현을 사용한다.
- 불확실한 내용은 추측하지 말고 사용자에게 확인 질문을 남긴다.

## 출력 형식
- 모든 문서는 한국어로 작성한다.
- 섹션: 프로젝트 설명, setup & build, 코드 스타일/가이드라인, 테스트, Boundaries.
- 최종 산출물은 `AGENTS_GUIDELINE.md`와 `AGENTS.md`다.

## 메모
- 브랜치 전략은 사용자가 직접 컨트롤하므로 포함하지 않는다.
