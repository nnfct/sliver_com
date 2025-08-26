# TEAM_GUIDE.md — Team Onboarding Guide

이 문서는 **팀원이 레포를 클론한 뒤 10분 안에 개발을 시작**할 수 있도록 환경 세팅과 폴더 구조 설명을 제공합니다.

---

## 1) Mise & PowerShell 설치

### Windows (PowerShell 7 권장)

```powershell
# PowerShell 7 설치 (한 번만)
winget install --id Microsoft.PowerShell -e

# mise 설치
winget install --id jdx.mise -e
mise --version
mise doctor
```

> Windows에는 기본적으로 PowerShell 5.1이 들어있지만, 개발 환경에서는 **PowerShell 7(pwsh)** 사용을 권장합니다. 5.1은 레거시 모듈용으로만 남겨두세요.

### macOS (zsh)

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
# 터미널을 닫고 새로 열면 자동 적용됩니다.
```

bash
brew install mise
mise --version
mise doctor

````

---

## 2) 프로젝트별 버전 설치 (프로필 등록 없이 바로 가능)
레포에는 `.mise.toml` **또는** `.tool-versions`가 포함되어 있습니다.
이 단계는 **프로필 훅을 등록하지 않아도** 안전합니다. 해당 폴더의 도구 버전을 먼저 설치하세요.

```bash
mise install
````

확인:

```bash
mise current
python --version
node --version
uv --version
```

---

## 3) (한 번만) 셸 프로필에 mise 활성화 — 자동 전환

> 이 단계를 **내 컴퓨터(내 계정)에서 한 번만** 해두면, 앞으로 어떤 프로젝트 폴더로 가도 그 폴더의 `.mise.toml`/`.tool-versions`에 지정된 **python/node/uv 버전으로 자동 전환**됩니다.

### Windows (PowerShell/pwsh)

```powershell
# 프로필 파일이 없으면 생성
if (!(Test-Path $PROFILE)) { New-Item -Type File -Path $PROFILE -Force }

# mise 훅 추가(문자 그대로 한 줄 저장)
Add-Content -Path $PROFILE -Value 'mise activate pwsh | Out-String | Invoke-Expression'

# 현재 세션에도 즉시 반영(또는 새 터미널을 열어도 됩니다)
mise activate pwsh | Out-String | Invoke-Expression
```

> 주의: `powershell`이 아니라 **`pwsh`** 입니다.

### macOS (zsh)

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
# 현재 셸에도 즉시 반영(또는 새 터미널)
eval "$(mise activate zsh)"
```

---

## 4) uv로 Python 환경 세팅 (mise Python 고정)

> 가상환경은 **mise가 고른 Python**으로 생성합니다.

### macOS / Linux

```bash
# 가상환경 생성 (처음 1회)
uv venv --python "$(mise which python)"

# 의존성 설치 (pyproject.toml 기반)
uv sync
```

### Windows (PowerShell/pwsh)

```powershell
# 가상환경 생성 (처음 1회)
uv venv --python (mise which python)

# 의존성 설치 (pyproject.toml 기반)
uv sync
```

---

## 5) 라이브러리 관리 규칙

- ✅ 새 패키지 추가

```bash
uv add fastapi
```

- ✅ 패키지 제거

```bash
uv remove fastapi
```

- 🚫 금지

```bash
pip install ...
```

> 항상 `uv add/remove` 로만 관리해야 팀 전체 버전이 동일하게 유지됩니다.

---

## 6) 실행 확인 (테스트)

```bash
# 가상환경 자동 사용
uv run python 실행시킬.py

# 또는 수동 활성화
# macOS/Linux
source .venv/bin/activate
# Windows PowerShell
.venv/Scripts/Activate.ps1

python 실행시킬.py
```

---

## 7) `__init__.py` 규칙

- Python에서 폴더를 **패키지로 인식**시키는 파일입니다.
- 코드가 들어가는 모든 폴더에는 빈 `__init__.py`를 넣어주세요. (내용 없어도 OK)

---

## 8) 요약 & 트러블슈팅

- **순서 권장:** ① mise 설치 → ② (각 프로젝트에서) `mise install` → ③ (한 번만) 프로필 훅 등록 → ④ `uv venv`/`uv sync`.
- 프로필 훅을 등록하지 않아도 `mise install`은 동작합니다. 다만 자동 전환은 훅 등록 이후부터 활성화됩니다.
- **버전 충돌**이 의심되면:

  - `mise current`, `mise which python`으로 실제 경로/버전을 확인
  - Python 메이저/마이너 변경 시 `.venv`를 지우고 4) 과정을 다시 실행
