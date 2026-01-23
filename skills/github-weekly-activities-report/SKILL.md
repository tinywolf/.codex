---
name: github-weekly-activities-report
description: 지난주 월요일부터 금요일까지 지정된 GitHub 사용자(프롬프트에 없으면 입력받음)의 커밋, PR 등 활동 내역을 찾아 요약 보고서를 작성할 때 사용한다. 기간 산정, 활동 수집, 요약 정리 흐름을 안내한다.
---

# GitHub 활동 보고

## 기간 산정
- “지난주 월요일~금요일” 범위를 명확히 계산해 조회 기간을 고정한다.
- 프롬프트에 GitHub 사용자가 명시되지 않았다면 먼저 사용자에게 대상 계정명을 요청한다.

## 활동 수집
- 기간 내 지정된 GitHub 사용자의 커밋, PR, 리뷰 등 활동을 리포지토리별로 수집한다.
- 가능한 경우 활동 링크, 제목, 상태(열림/머지/닫힘)와 기여 내용을 함께 확보한다.
- 저장소를 클론해둔 경우 git 로그로 커밋을 조회한다. 예: `git log --author="<user>" --since="2024-05-13" --until="2024-05-17" --pretty="%ad %h %s" --date=short`.
- gh CLI로 GitHub 활동을 수집한다. 예:
  - 커밋: `gh api repos/<owner>/<repo>/commits --paginate -f author=<user> -f since=2024-05-13T00:00:00Z -f until=2024-05-17T23:59:59Z`
  - PR: `gh api search/issues -f q="author:<user> type:pr created:2024-05-13..2024-05-17"`
  - 리뷰 활동: `gh api search/issues -f q="reviewed-by:<user> type:pr updated:2024-05-13..2024-05-17"`

## 보고서 작성
- 요약에는 기간, 주요 활동 수, 하이라이트(예: 머지된 PR, 주요 커밋), 미해결 항목을 포함한다.
- 세부 목록은 활동별로 날짜, 저장소, 제목/메시지, 링크를 정리한다.
