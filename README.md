# So-Momeet Monorepo (MVP)

구성: backend(FastAPI), admin(Django Admin), mobile(React Native)

## 요구 도구
- mise, uv, Node.js LTS, Python 3.11, PostgreSQL

## 주요 작업 (PowerShell)
- API 서버: `mise run :api`
- 테스트: `mise run :test`
- 관리자(Django): `mise run :admin`

환경 변수는 루트 `.env`(예시 `.env.example`)를 사용합니다.
