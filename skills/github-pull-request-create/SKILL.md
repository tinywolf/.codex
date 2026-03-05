---
name: github-pull-request-create
description: 현재 브랜치 변경을 기반으로 master 또는 main을 대상(base)으로 Pull Request를 작성해야 할 때 사용한다. PR 템플릿(.github/pull_request_template.md) 준수, 한국어 내용 작성, 코드 주석에 언급된 링크 추출, PR 생성 전 초안 검토 절차를 포함한다.
---

# Pull Request 생성

## 준비
- 현재 브랜치의 변경 범위를 확인하고 base 브랜치를 master/main 중 맞는 쪽으로 정한다.
- `.github/pull_request_template.md` 존재 여부를 확인해 템플릿 구조와 필수 항목을 파악한다.
- 주석에 새로 추가된 링크가 있으면 PR 본문에 포함할 참고 링크 목록으로 정리한다.

## 작성 및 검토
- 템플릿을 따르되 모든 내용은 한국어로 작성한다.
- 제목은 변경 목적을 간결히 표현한다.
- 본문에 주요 변경점, 테스트 결과, 영향 범위, 참고 링크를 정리한다.
- 생성 전에 초안 내용을 공유해 승인을 받은 후 PR을 생성한다.

## 생성
- 승인 후에만 실제 PR을 생성한다. 생성 후 링크를 공유한다.
- gh CLI를 사용한다: `gh pr create --base main --title "<제목>" --body-file <본문파일>` 또는 `--body "<본문>"` 등으로 생성하며, 템플릿이 있으면 `--fill`로 채운 뒤 필요 내용을 덧붙인다.
- 링크는 `gh pr view --web` 또는 출력된 URL을 사용해 공유한다.
