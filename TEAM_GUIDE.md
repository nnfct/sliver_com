# TEAM_GUIDE.md — Team Onboarding Guide

이 문서는 **레포를 클론한 뒤 10분 안에 개발을 시작**할 수 있도록 Windows/macOS 환경 세팅과 폴더 구조/운영 규칙을 제공합니다.

---

## Windows용 순서

### 1) 설치

```powershell
# PowerShell 7 (pwsh) 설치 — 한 번만
winget install --id Microsoft.PowerShell -e

# mise 설치
winget install --id jdx.mise -e

# 확인
pwsh -v
where.exe mise
mise --version
mise doctor
```

> Windows PowerShell(5.1) 대신 **PowerShell 7(pwsh)** 사용 권장.

#### (설치 꼬일 때 mise 제거 후 재설치)

```powershell
Stop-Process -Name mise -Force -ErrorAction SilentlyContinue
winget uninstall --id jdx.mise -e
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Programs\mise"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\jdx.mise_Microsoft.Winget.Source_*"
winget install --id jdx.mise -e
```

---

### 2) 프로젝트 버전 설치

```powershell
mise install
mise current
python --version
node --version
uv --version
```

---

### 3) PowerShell 프로필 활성화

```powershell
# 프로필 파일 생성
New-Item -ItemType Directory -Force (Split-Path $PROFILE)
New-Item -ItemType File -Force $PROFILE
notepad $PROFILE
```

#### 옵션 A (자동완성 + 환경 세팅)

```powershell
(& mise activate powershell) | Out-String | Invoke-Expression
```

#### 옵션 B (안정 모드: 환경만)

```powershell
$mise = (Get-Command mise -ErrorAction SilentlyContinue)?.Source
if ($mise) {
  (& $mise hook-env -s powershell) | Invoke-Expression
}
```

재실행 후:

```powershell
Get-Command mise | fl CommandType,Source
mise current
```

---

### 4) uv로 Python 가상환경/의존성 세팅

```powershell
# 가상환경 생성 (프로젝트별 최초 1회)
uv venv --python (mise which python)

# 의존성 설치 (pyproject.toml 기반)
uv sync

# 실행
uv run python your_script.py
# 또는
.\.venv\Scripts\Activate.ps1
python your_script.py
```

**팀 규칙**

```powershell
uv add fastapi   # ✅ 패키지 추가
uv remove fastapi
# pip install ❌ 금지
```

---

### 5) 자주 쓰는 mise 명령어

```powershell
mise install
mise current
mise which python
mise which node
mise exec python@3.12 -- python -V
mise exec node@20 -- node -v
mise ls-remote python
mise ls-remote node
mise list
```

**`.mise.toml` 예시**

```toml
[tools]
python = "3.12"
node   = "22.18.0"
uv     = "latest"
yarn   = "latest"
```

---

### Windows 트러블슈팅

- `notepad $PROFILE` → 경로 없음 → `New-Item`으로 파일 생성 후 다시 시도
- `mise` 실행 시 Null 참조 → `$PROFILE` 안의 `function mise { ... }` 블록 삭제 후 재설정
- `winget uninstall` 오류 → 수동 폴더 삭제 후 재설치
- Python/Node 버전이 다를 때 → `.venv` 삭제 후 다시 생성

---

## macOS용 순서

### 1) 설치

```bash
brew install mise
mise --version
mise doctor
```

#### 꼬였을 때

```bash
brew uninstall mise
brew install mise
```

---

### 2) 프로젝트 버전 설치

```bash
mise install
mise current
python --version
node --version
uv --version
```

---

### 3) zsh 프로필 활성화

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
# 즉시 반영
eval "$(mise activate zsh)"
```

---

### 4) uv로 Python 가상환경/의존성 세팅

```bash
# 가상환경 생성 (최초 1회)
uv venv --python "$(mise which python)"

# 의존성 설치
uv sync

# 실행
uv run python your_script.py
# 또는
source .venv/bin/activate
python your_script.py
```

**팀 규칙**

```bash
uv add fastapi   # ✅ 패키지 추가
uv remove fastapi
# pip install ❌ 금지
```

---

### 5) 자주 쓰는 mise 명령어

```bash
mise install
mise current
mise which python
mise which node
mise exec python@3.12 -- python -V
mise exec node@20 -- node -v
mise ls-remote python
mise ls-remote node
mise list
```

**`.mise.toml` 예시**

```toml
[tools]
python = "3.12"
node   = "22.18.0"
uv     = "latest"
yarn   = "latest"
```

---

## 폴더 구조 & `__init__.py`

- 코드가 들어가는 모든 폴더는 Python 패키지로 인식되도록 `__init__.py`를 둡니다.
- 이유: 오타/상대경로 이슈 방지 + 정적 분석/리팩토링 도구 호환.

---

## 팀 운영 원칙

- 버전 고정/재현성: `.mise.toml`/`pyproject.toml` 기준
- 명령 일관성: Python 패키지 관리 = `uv add/remove`
- 문제 발생 시: `mise current/which`, `uv --version`으로 원인 분리
- 문서화: 변경 시 본 문서를 PR로 업데이트

---

### 부록 — 왜 이렇게 쓰나?

- **mise**: 언어별 도구를 단일 문법으로 관리 → 온보딩/CI 단순화
- **uv**: pip/venv 대비 속도·재현성 우수, 락파일 기반 관리
- **옵션 A vs B**: 생산성(자동완성) ↔ 안정성(경량) 트레이드오프
