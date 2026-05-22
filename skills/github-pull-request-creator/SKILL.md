---
name: github-pull-request-creator
description: 현재 브랜치 변경을 기반으로 master 또는 main을 대상(base)으로 Pull Request를 작성해야 할 때 사용한다. PR 템플릿 탐색 및 준수, 한국어 내용 작성, 코드 주석에 언급된 링크 추출, PR 생성 전 초안 검토 절차를 포함한다.
---

# Pull Request 생성

## 준비
- 현재 브랜치의 변경 범위를 확인하고 base 브랜치를 master/main 중 맞는 쪽으로 정한다.
- `git rev-parse --show-toplevel`로 저장소 루트를 확인한 뒤, 저장소 루트 기준으로 다음 PR 템플릿 후보를 확인해 템플릿 구조와 필수 항목을 파악한다: `.github/pull_request_template.md`, `.github/PULL_REQUEST_TEMPLATE.md`, `pull_request_template.md`, `PULL_REQUEST_TEMPLATE.md`, `docs/pull_request_template.md`, `docs/PULL_REQUEST_TEMPLATE.md`, `.github/PULL_REQUEST_TEMPLATE/*.md`.
- 템플릿 탐색 시 `.github`는 GitHub 설정 디렉터리이므로 숨김 디렉터리로 간주해 건너뛰지 않는다. `rg --files` 등 숨김 경로를 기본 제외하는 도구를 사용할 때는 `--hidden`을 사용하거나 `$repo_root/.github` 경로를 직접 확인한다.
- 위 후보에서 템플릿을 찾지 못했다면 `$repo_root/.github`와 `$repo_root/.github/PULL_REQUEST_TEMPLATE` 존재 여부를 명시적으로 다시 확인하고, 해당 디렉터리 안의 PR 템플릿 후보를 재검색한다.
- `.github/PULL_REQUEST_TEMPLATE/*.md`처럼 템플릿이 여러 개라면 변경 성격에 가장 맞는 템플릿을 선택하고, 판단이 애매하면 후보를 공유해 사용자에게 확인한다.
- 주석에 새로 추가된 링크가 있으면 PR 본문에 포함할 참고 링크 목록으로 정리한다.

## 작성 및 검토
- 템플릿을 따르되 모든 내용은 한국어로 작성한다.
- 제목은 변경 목적을 간결히 표현한다.
- 본문에 주요 변경점, 테스트 결과, 영향 범위, 참고 링크를 정리한다.
- 이슈 링크나 참조 링크가 없다면 해당 섹션은 생략한다.
- 생성 전에 초안 내용을 공유해 승인을 받은 후 PR을 생성한다.

## 생성
- 승인 후에만 실제 PR을 생성한다. 생성 후 링크를 공유한다.
- 실제 PR을 생성하기 전에 PR을 누구에게 할당할지 확인한다. 사용자가 사전에 지정하지 않은 경우에는 기본값 `@me`를 함께 제시해 승인 여부를 묻는다.
- 사용자가 초안 승인을 하면서도 별도의 할당자를 지정하지 않으면 기본값 `@me`로 할당한다.
- gh CLI를 사용한다: `gh pr create --base main --assignee <할당자> --title "<제목>" --body-file <본문파일>` 또는 `--body "<본문>"` 등으로 생성한다. 템플릿이 있으면 템플릿 내용을 반영해 본문 파일을 만든 뒤 `--body-file`로 전달하거나, 시작 본문으로 템플릿을 직접 지정할 때는 `--template <템플릿파일>`을 사용한다. `--fill`은 커밋 정보로 제목/본문을 자동 채우는 옵션이므로 템플릿 적용 용도로 사용하지 않는다.
- 링크는 `gh pr view --web` 또는 출력된 URL을 사용해 공유한다.
