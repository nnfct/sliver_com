# Azure 사전 준비 체크리스트 (MVP)

## 1) 구독/리소스 그룹/네이밍
- [ ] 구독 확정, 리소스 그룹 `rg-somomeet-dev`
- [ ] 네이밍 컨벤션(지역/환경/리소스타입 접미사) 확정

## 2) Azure AD B2C
- [ ] 테넌트 생성 및 연결된 구독 매핑
- [ ] 앱 등록(모바일/웹), 리다이렉트 URI(로그인/로그아웃) 등록
- [ ] 사용자 흐름 정책(SignIn/SignUp, Password Reset) 생성
- [ ] 소셜 로그인 키(카카오, Google, Apple) 발급·연동
- [ ] 사용자 속성 매핑(email, name, age_range 등)

## 3) 데이터/스토리지
- [ ] Azure Database for PostgreSQL(Flexible) 생성, 방화벽/Private Endpoint
- [ ] Blob Storage 계정+컨테이너(`uploads`) 생성, CORS 설정
- [ ] 백업/보존 정책(매일 스냅샷, 7~14일) 명세

## 4) 실시간/메시징
- [ ] Azure Communication Services 리소스 생성
- [ ] 토큰 발급 API 플로우 설계(서버 발급→앱 전달)
- [ ] 메시지 크기/레이트 제한 정책

## 5) 보안/시크릿/네트워크
- [ ] Key Vault 생성, 시크릿 저장(AD B2C, DB, ACS, Blob, OpenAI)
- [ ] API Management(레이트리밋) 도입 여부 검토(후순위)
- [ ] Front Door+WAF(출시 직전) 계획 수립

## 6) 관측/알림
- [ ] Application Insights/Log Analytics 워크스페이스 생성
- [ ] 핵심 대시보드와 알람 룰(KR/에러율/성능)

## 7) DevOps
- [ ] GitHub Actions OIDC 연동 배포(환경별)
- [ ] Lint/Test/Build/Deploy 파이프라인 템플릿
- [ ] Alembic 자동 마이그레이션 단계

## 8) 문서/정책
- [ ] 개인정보 처리방침/이용약관 초안
- [ ] 신고 처리 런북(SLA, 템플릿)
- [ ] 접근성 체크리스트 운영 문서
