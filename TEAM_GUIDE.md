# 팀 가이드 — 10분 만에 개발 시작하기

이 프로젝트를 처음 시작하는 분들을 위한 가이드입니다. 
순서대로 따라하시면 10분 안에 개발을 시작할 수 있습니다.

⚠️ **중요**: 모든 명령어는 반드시 이 프로젝트 폴더(레포 루트)에서 실행하세요.

---

# 🪟 Windows 사용자

## 1단계: 필수 도구 설치

```powershell
# PowerShell 7 설치 (한 번만)
winget install --id Microsoft.PowerShell -e

# mise 설치 (개발 도구 관리자)
winget install --id jdx.mise -e

# 설치 확인
pwsh -v
mise --version
```

## 1-1단계: IDE 터미널 설정 (중요!)

**VS Code 사용자:**
1. `Ctrl + ,` → 설정 열기
2. "terminal.integrated.defaultProfile.windows" 검색
3. 값을 `PowerShell`로 변경 (Widows PowerShell 아님)

**또는 settings.json에 직접 추가:**
```json
{
  "terminal.integrated.defaultProfile.windows": "pwsh"
}
```

이제 IDE에서 터미널을 열면 PowerShell 7이 기본으로 실행됩니다!

## 2단계: 프로젝트 개발 도구 설치

```powershell
# 프로젝트에 필요한 모든 도구를 자동으로 설치
mise install

# 설치된 버전 확인
mise current
python --version
node --version
yarn --version
uv --version
```

## 3단계: PowerShell 설정

**자동 설정 (권장):**
```powershell
# PowerShell 프로필에 mise 설정 추가
if (!(Test-Path $PROFILE)) { New-Item -ItemType File -Path $PROFILE -Force }
Add-Content $PROFILE 'Invoke-Expression (& mise hook-env -s pwsh)'

# 즉시 적용
. $PROFILE
```

**수동 설정 (문제가 있을 때):**
```powershell
# 매번 새 터미널에서 실행
Invoke-Expression (& mise hook-env -s pwsh)
```

## 4단계: 프로젝트 의존성 설치

```powershell
# Python 의존성 설치
uv sync

# Node.js 의존성 설치  
yarn install
```

## 5단계: 개발 서버 실행

```powershell
# 전체 서비스 실행 (추천)
yarn dev

# 또는 개별 서비스 실행
yarn dev:api      # FastAPI 백엔드만
yarn dev:web      # Next.js 웹만
yarn dev:mobile   # Expo 모바일만
```

## 🔧 Windows 문제 해결

**mise가 인식되지 않을 때:**
```powershell
# mise 재설치
winget uninstall --id jdx.mise -e
winget install --id jdx.mise -e
```

**Python/Node 버전이 다를 때:**
```powershell
# 가상환경 재생성
Remove-Item -Recurse -Force .venv
uv sync
```

---

# 🍎 macOS 사용자

## 1단계: 필수 도구 설치

```bash
# mise 설치 (개발 도구 관리자)
brew install mise

# 설치 확인
mise --version
```

## 2단계: 프로젝트 개발 도구 설치

```bash
# 프로젝트에 필요한 모든 도구를 자동으로 설치
mise install

# 설치된 버전 확인
mise current
python --version
node --version
yarn --version
uv --version
```

## 3단계: zsh 설정

```bash
# mise 자동 활성화 설정
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc

# 즉시 적용
eval "$(mise activate zsh)"
```

## 4단계: 프로젝트 의존성 설치

```bash
# Python 의존성 설치
uv sync

# Node.js 의존성 설치
yarn install
```

## 5단계: 개발 서버 실행

```bash
# 전체 서비스 실행 (추천)
yarn dev

# 또는 개별 서비스 실행
yarn dev:api      # FastAPI 백엔드만
yarn dev:web      # Next.js 웹만
yarn dev:mobile   # Expo 모바일만
```

## 🔧 macOS 문제 해결

**mise가 인식되지 않을 때:**
```bash
# mise 재설치
brew uninstall mise
brew install mise
```

**Python/Node 버전이 다를 때:**
```bash
# 가상환경 재생성
rm -rf .venv
uv sync
```

---

# 📋 자주 사용하는 명령어

## 개발 중에 자주 쓰는 명령어들

```bash
# 개발 서버 실행
yarn dev                 # 전체 서비스
yarn dev:api            # 백엔드만
yarn dev:web            # 웹만
yarn dev:mobile         # 모바일만

# 빌드
yarn build              # 전체 빌드
yarn build:web          # 웹 빌드
yarn build:mobile       # 모바일 빌드

# 코드 검사
yarn lint               # 코드 스타일 검사
yarn type-check         # 타입 검사

# 패키지 관리
yarn add 패키지명        # 패키지 추가
yarn remove 패키지명     # 패키지 제거
uv add 패키지명          # Python 패키지 추가
uv remove 패키지명       # Python 패키지 제거
```

## 문제가 생겼을 때

```bash
# 현재 설치된 도구 버전 확인
mise current

# 특정 도구의 경로 확인
mise which python
mise which node
mise which yarn
```

---

# ⚡ 팀 규칙

## ✅ 이렇게 하세요

```bash
# 패키지 설치
yarn add 패키지명           # Node.js 패키지
uv add 패키지명             # Python 패키지

# 개발 서버 실행
yarn dev                   # 권장 방법
```

## ❌ 이렇게 하지 마세요

```bash
npm install               # yarn 대신 사용 금지
pip install               # uv 대신 사용 금지
```

---

# 💡 왜 이런 도구들을 사용하나요?

- **mise**: 프로젝트마다 다른 Python/Node 버전을 자동으로 관리
- **uv**: pip보다 빠른 Python 패키지 관리자  
- **yarn**: npm보다 안정적인 Node.js 패키지 관리자

궁금한 점이 있으면 팀에 언제든 물어보세요! 🙂