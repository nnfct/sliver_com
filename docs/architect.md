# 아키텍처 제안서 (MVP 기준)

본 문서는 프로젝트의 웹·앱·관리(경량 Admin)를 어떻게 구성/운영할지에 대한 MVP 지향 아키텍처 가이드입니다.

## 1) 목표와 원칙
- MVP Must 기능(가입/로그인, 프로필, 소모임, 1:1/모임 채팅, 추천 v0)을 4주 내 완주
- 변경 비용 최소화: 단일 리포/단일 파이프라인, 공용 라이브러리 재사용
- 접근성/보안/관측 가능성 기본 탑재(AA, OIDC, 로그/트레이스)
- Should/AI 기능은 Feature Flag로 분리

## 2) 결론: 지금은 모노레포(권장), 나중에 필요 시 분리
MVP 단계에선 단일 모노레포로 속도와 동기화를 극대화합니다. 팀/릴리스가 분화되면 서비스별 분리를 고려합니다(§9 참고).

## 3) 저장소 구조(제안)
```
so-momeet/
├── apps/
│   ├── web/             # Next.js(사용자 웹 + 경량 Admin: /admin 라우트 권장)
│   ├── mobile/          # React Native(Expo)
│   └── api/             # FastAPI(ASGI), OpenAPI 스펙 소스
├── admin-retool/        # (선택) Retool 구성/SQL/스크립트 백업
├── packages/
│   ├── api-client/      # OpenAPI → TypeScript SDK (웹/모바일 공용)
│   ├── ui/              # 디자인 토큰/공용 컴포넌트(선택, 웹/RN 분리 관리)
│   └── config/          # ESLint/Prettier/tsconfig 등 공용 설정
├── docs/                # 결정 기록/전략/가이드(본 문서 포함)
├── .env.example         # 공통 환경 변수 샘플(루트)
└── mise.toml            # 도구 버전 고정
```

## 4) 채택 기술
- 웹: Next.js(React) — 서버 액션/Route Handler로 운영 뷰에 유용
- 앱: React Native(Expo) — iOS/Android 동시 개발, EAS 배포 용이
- API: FastAPI + PostgreSQL — 비동기/타이핑 우수, OpenAPI 자동화
- 파일: Azure Blob Storage(SAS 업로드)
- 인증: Azure AD B2C(OIDC: Google/카카오/Apple + 이메일 옵션)
- 실시간: Azure Communication Services(1:1/모임 채팅 토큰 발급)
- 운영/보안: Key Vault, GitHub Actions, Application Insights

## 5) 경량 Admin 전략(Next.js Admin 우선, Retool 보완)
- Next.js Admin: /admin 라우트로 최소 CRUD·대시보드 구현(역할/권한, 감사 로그 포함)
- Retool: 운영자 빠른 워크플로우가 필요할 때 병행(쓰기 액션은 서버 API 경유, 감사 기록 필수)

## 6) 경계와 계약(Interfaces)
- OpenAPI 스펙: apps/api에서 단일 소스 관리 → packages/api-client 자동 생성
- 인증/인가: OIDC 로그인, 서버 세션 또는 액세스 토큰 처리, RBAC(Role/Scope) 고정
- 미디어: Blob SAS URL 기반 업/다운로드, MIME/크기 검증은 서버에서 수행
- 채팅: `/chat/token`(ACS 토큰), 1:1/모임 채널 발급 API, 클라이언트는 SDK로 연결

## 7) 핵심 데이터 모델(초안)
- users, profiles(사진/닉네임/인증/취미/주소/알림설정), tags
- groups, memberships(역할/상태), posts, comments
- events(RSVP: 참석/미정/불참), reports(신고), blocks(차단)

## 8) CI/CD·환경 변수
- 파이프라인: 경로 기반 빌드/테스트(터보/워크스페이스 캐시), 프리뷰 브랜치 배포
- 배포(예):
  - web: Azure Web App/Static Web Apps(선호 환경에 맞춤)
  - api: Azure App Service(컨테이너) 또는 Azure Functions(선택)
  - mobile: EAS 내부 배포 트랙
- 환경 변수(예): DATABASE_URL, SECRET_KEY, AD_B2C_*, ACS_CONNECTION_STRING, BLOB_*, OPENAI_*
  - 루트 .env.example → 각 앱 .env 로 분배, 시크릿은 Key Vault/Actions 변수 사용

## 9) 언제 분리 레포로 전환하나
- 팀/릴리스 분화: 웹·앱·API의 배포 주기가 상이해 충돌/대기 증가
- 보안/권한: 파트너/외부가 특정 파트만 접근해야 하는 경우
- 빌드 시간 급증: 캐시/분할로도 해소 안 될 정도로 느릴 때
- 독립 확장성: 특정 서비스가 별도 스케일/인프라를 요구

## 10) 품질 게이트(공통)
- Build/Lint/Test 자동화: p95 응답, 오류율, 접근성(AA), E2E 시나리오
- 보안: 의존성 스캔, 시크릿 린트, JWT/권한 테스트, 감사 로그 적재

## 11) 실행 순서(요약)
1) 모노레포 초기화(폴더/워크스페이스) → API OpenAPI 최소 스펙 정의
2) packages/api-client 생성 → 웹/앱에서 공용 SDK 사용
3) 웹 /admin 최소 CRUD + 앱 로그인/온보딩 + 기본 피드/소모임 CRUD
4) 채팅(ACS 토큰 발급→클라이언트 연결), 이미지 업로드(SAS)
5) QA/접근성/성능 스모크 → 베타 배포

부록: 분리 시 마이그레이션 팁
- OpenAPI·RBAC·이벤트 스키마가 인터페이스 역할을 하므로 레포 분리 시에도 변경 최소화
- 공용 패키지(packages/*)는 사설 레지스트리로 옮겨 배포
