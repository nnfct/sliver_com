# 구현 준비 계획 (MVP, 4주)

본 문서는 project.md, task.md를 바탕으로 실제 개발 착수를 위한 사전 준비와 W1~W2 초기 부트스트랩을 단계별로 안내합니다.

## 1) 사전 리스크 및 선결 과제
- AD B2C 준비 리드타임
  - 테넌트/정책 생성, 소셜 앱 키(카카오/Google/Apple), 리다이렉트 URI 승인에 2~5일 소요 가능
  - 대응: W1 Day1에 테넌트·앱 등록·리다이렉트 URI를 즉시 확정/신청
- 스토어/인증서
  - Apple Developer 계정(기업/개인), 앱 서명/프로비저닝 프로파일 준비 필요
  - 대응: 내부 테스트트랙 우선, EAS 혹은 내부 배포 채널 검토(웹은 Closed Beta 대비)
- 데이터보호/정책
  - 개인정보 최소 수집, 보관 기간·파기 정책, 신고 처리 SLA
  - 대응: 개인정보 처리방침/이용약관 초안 W1에 확정
- 접근성 구현 리스크
  - 130% 폰트 확대·명암비·터치 영역 기준 미충족 가능성
  - 대응: 디자인 토큰/테마 초기에 고정, 자동 E2E 접근성 체크 추가
- 실시간/ACS 비용·제한
  - 메시지/동시 연결 한도 및 비용
  - 대응: 메시지 크기 제한, 이미지 전송은 Blob 경유, 텍스트 우선

## 2) 로컬/개발 환경 준비 (Windows, PowerShell)
- 필수 도구
  - Node.js LTS, pnpm 또는 npm
  - Python 3.11+, pip
  - PostgreSQL 14+ (로컬 또는 Azure)
  - Git, OpenSSL
- 팀 표준
  - 커밋 규칙: Conventional Commits
  - 코드 스타일: Black/ruff(Py), Prettier/ESLint(TS)

## 3) 저장소 구조(초기)
```
so-momeet/
├── backend/              # FastAPI + SQLAlchemy + Alembic
├── admin/                # Django Admin (운영도구)
├── mobile/               # React Native 앱
├── docs/                 # 아키텍처/결정 기록
└── .env.example          # 공통 환경 변수 샘플(루트)
```

## 4) 백엔드(FastAPI) 부트스트랩
- 핵심 모듈
  - 인증: AD B2C OIDC(JWT 검증) → `/auth/me`
  - 사용자/프로필/태그: CRUD + 스키마 확정
  - 추천 v0: 태그 유사도 기반 엔드포인트
  - 소모임/게시/댓글: 최소 CRUD
  - 채팅: ACS 토큰 발급 엔드포인트(`/chat/token`)
- 마이그레이션
  - Alembic 초기 스키마(users, profiles, tags, groups, posts, comments)
- 품질 게이트
  - pytest 스모크, ruff/black, mypy 옵션

## 5) 관리자(Django Admin)
- 같은 DB(PostgreSQL) 사용, 핵심 모델 등록
- 스태프 권한·감사 로그 미들웨어 설정(기본)

## 6) 모바일 앱(RN)
- 로그인 플로우: AD B2C(OIDC) WebView/Redirect
- 온보딩: 관심사 선택, 프로필 저장
- 피드/글쓰기/댓글(이미지 업로드는 Blob SAS URL)
- DM: 백엔드에서 발급받은 ACS 토큰으로 1:1 채널 연결
- 접근성 토글: 폰트 스케일 3단, 고대비 모드

## 7) 인프라/보안(요약)
- Azure AD B2C, PostgreSQL(Flexible), Blob, ACS, App Insights
- Key Vault로 시크릿 관리, GitHub Actions에서 OIDC 연동 배포
- 로깅/트레이스: OpenTelemetry → App Insights

## 8) 환경 변수/시크릿(요약)
- 루트 `.env`(배포 전 Key Vault로 이관)
  - DATABASE_URL, SECRET_KEY, AD_B2C_*, ACS_CONNECTION_STRING, BLOB_*, OPENAI_*

## 9) W1~W2 착수 플랜(체크리스트)
- W1 Day1–2
  - [ ] AD B2C 테넌트/앱 등록/정책, 리다이렉트 URI 확정
  - [ ] Azure PostgreSQL/Blob/ACS/App Insights 리소스 생성
  - [ ] 백엔드 스켈레톤 + Alembic init, `/health`, `/auth/me`
  - [ ] 모바일 템플릿, 로그인 화면 틀, 접근성 토글
- W1 Day3–5
  - [ ] users/profiles/tags 스키마/엔드포인트
  - [ ] 그룹/게시/댓글 CRUD 초안, 이미지 업로드 경로
  - [ ] Django Admin 부트스트랩/모델 등록
  - [ ] CI: Lint/Test/Build 파이프라인
- W2
  - [ ] 추천 v0 API + 홈 피드 연동
  - [ ] DM 토큰 발급 + 기본 송수신(테스트 채널)
  - [ ] 신고/차단 API 스텁(Feature Flag)

## 10) 수용 기준(초기)
- API: `/health` 200, `/auth/me` 토큰 검증, 기본 CRUD 200/201
- 앱: 로그인→온보딩 저장→피드 렌더→게시/댓글 성공
- 채팅: 1:1 텍스트 송수신(이미지 링크는 Blob 업로드 후 URL)
