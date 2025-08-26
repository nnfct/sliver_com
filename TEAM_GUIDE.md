# TEAM_GUIDE.md — Team Onboarding Guide (Windows/macOS 공통)

이 문서는 **레포를 클론한 뒤 10분 안에 개발을 시작**할 수 있도록 환경 세팅과 폴더 구조/운영 규칙을 제공합니다.

---

## 0) 무엇을 왜 쓰나 (파인만식 한 줄 요약)

- **mise**: Python/Node 등 **언어·도구 버전 관리자** (pyenv+nvm 올인원).
- **uv**: Python 패키지/가상환경 **초고속 관리자**.
- 둘을 함께 쓰면, **프로젝트별 정확한 버전**을 자동으로 적용하고, 팀 전체가 **동일 환경**을 유지합니다.

---

## 1) 설치 (Windows, macOS)

### Windows (PowerShell 7 권장)

```powershell
# PowerShell 7 (pwsh) 설치 — 한 번만
winget install --id Microsoft.PowerShell -e

# mise 설치
winget install --id jdx.mise -e
```

확인:

```powershell
pwsh -v
where.exe mise
mise --version
mise doctor
```

> **TIP**: Windows PowerShell(5.1) 대신 **PowerShell 7(pwsh)** 를 기본으로 사용하세요. 셸 호환성/안정성이 좋습니다.

#### (winget이 꼬일 때 대안)

- Scoop:

  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force
  iwr -useb get.scoop.sh | iex
  scoop install mise
  ```

- 수동(ZIP): GitHub Releases에서 mise Windows zip 다운로드 →
  `C:\Users\<USER>\AppData\Local\Programs\mise\bin`에 압축 해제 → PATH 추가.

### macOS (zsh)

```bash
brew install mise
mise --version
mise doctor
```

---

## 2) 기존 mise 제거 후 재설치 (꼬였을 때)

이미 mise가 설치되어 있는데 오류가 나거나 버전이 꼬였을 경우, **완전히 삭제 후 재설치**하세요.

### Windows

1. 실행 중인 프로세스 종료

```powershell
Stop-Process -Name mise -Force -ErrorAction SilentlyContinue
```

2. WinGet 제거 (실패할 경우 무시 가능)

```powershell
winget uninstall --id jdx.mise -e
```

3. 폴더 직접 삭제

```powershell
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Programs\mise" -ErrorAction SilentlyContinue
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\jdx.mise_Microsoft.Winget.Source_*" -ErrorAction SilentlyContinue
```

4. PATH 환경변수에 mise 관련 경로가 남았는지 확인하고 있으면 제거.
5. 재부팅 후 재설치

```powershell
winget install --id jdx.mise -e
```

### macOS

```bash
brew uninstall mise
brew install mise
```

---

## 3) 프로젝트 버전 일괄 설치 (프로필 없이 바로 가능)

레포에는 `.mise.toml`(또는 `.tool-versions`)이 포함됩니다.
해당 폴더에서 다음만 실행하면 **필요한 언어/도구를 자동 설치**합니다.

```bash
mise install
```

확인:

```bash
mise current
python --version
node --version
uv --version
```

---

## 4) 셸 “활성화” — 디렉터리 진입 시 자동 전환

> 이 단계는 **내 PC에서 한 번만** 해두면, 이후 어떤 프로젝트 폴더로 가도 `.mise.toml`의 버전이 **자동 적용**됩니다.

### Windows (PowerShell 7 / pwsh)

1. 프로필 파일이 없으면 생성

```powershell
# 경로 확인
echo $PROFILE
# 폴더/파일 생성
New-Item -ItemType Directory -Force (Split-Path $PROFILE)
New-Item -ItemType File -Force $PROFILE
```

2. **활성화 방식 선택 — 옵션 A/B 중 하나만**

**옵션 A (표준: 자동완성 + 환경 세팅)**

```powershell
# 프로필 편집
notepad $PROFILE
# 아래 한 줄 추가 후 저장
(& mise activate powershell) | Out-String | Invoke-Expression
```

**옵션 B (안정 모드: 환경 변수만, 자동완성 제외)**

```powershell
notepad $PROFILE
# 아래 블록 추가 후 저장
$mise = (Get-Command mise -ErrorAction SilentlyContinue)?.Source
if ($mise) {
  (& $mise hook-env -s powershell) | Invoke-Expression
}
```

> 차이점: **A는 자동완성/프롬프트**까지 포함(풍부하지만 가끔 충돌 가능), **B는 경량/안정**(환경만 주입).

3. 새 pwsh 열고 확인:

```powershell
Get-Command mise | fl CommandType,Source     # Application 이어야 정상
mise current
```

### macOS (zsh)

```bash
echo 'eval "$(mise activate zsh)"' >> ~/.zshrc
# 현재 셸에도 즉시 반영
eval "$(mise activate zsh)"
```

---

## 5) uv로 Python 가상환경/의존성 세팅

> 가상환경은 **mise가 고른 Python**으로 만듭니다.

```bash
# 가상환경 생성 (최초 1회)
uv venv --python "$(mise which python)"   # macOS/Linux
# Windows PowerShell
uv venv --python (mise which python)

# 의존성 설치 (pyproject.toml 기반)
uv sync
```

실행:

```bash
uv run python your_script.py
# 또는
# macOS/Linux: source .venv/bin/activate
# Windows:     .\.venv\Scripts\Activate.ps1
python your_script.py
```

**팀 규칙**

```bash
# ✅ 패키지 추가/제거는 uv로만
uv add fastapi
uv remove fastapi

# 🚫 pip 직접 사용 금지 (팀 버전 불일치 유발)
pip install ...
```

---

## 6) mise 자주 쓰는 명령 (실무 단골)

```bash
# 프로젝트 파일(.mise.toml) 기준으로 도구 설치
mise install

# 현재 디렉터리에서 적용 중인 버전 보기
mise current

# 실제 사용 중인 바이너리 경로 확인
mise which python
mise which node

# 일회성으로 특정 버전 실행 (환경 안 더럽힘)
mise exec python@3.12 -- python -V
mise exec node@20 -- node -v

# 설치 가능한 버전 탐색
mise ls-remote python
mise ls-remote node

# 로컬에 설치된 버전/요청 버전 보기
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

## 7) Windows 트러블슈팅 모음

### A) `notepad $PROFILE` → “지정된 경로를 찾을 수 없습니다.”

- 원인: 프로필 파일이 아직 없음.
- 해결:

  ```powershell
  New-Item -ItemType Directory -Force (Split-Path $PROFILE)
  New-Item -ItemType File -Force $PROFILE
  notepad $PROFILE
  ```

### B) `mise` 실행 시 PowerShell 오류(Null 참조, `Parser::ParseInput` 등)

- 원인: 예전 프로필에 남아 있던 **`function mise { ... }`** 훅이 깨져서 **EXE 대신 함수**가 먼저 잡힘.
- 진단:

  ```powershell
  Get-Command mise -All    # Function: mise 가 보이면 그게 범인
  ```

- 임시 조치:

  ```powershell
  Remove-Item Function:mise -ErrorAction SilentlyContinue
  ```

- 영구 조치: `$PROFILE` 열어 **`function mise { ... }` 블록 삭제** 후, 위 **옵션 A 또는 B** 로 다시 설정.

### C) `winget uninstall jdx.mise` 중 `remove_all`/권한 오류

1. 모든 터미널 종료 → **관리자 pwsh** 실행
2. 잔여물 제거:

   ```powershell
   Stop-Process -Name mise -Force -ErrorAction SilentlyContinue
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Programs\mise" -ErrorAction SilentlyContinue
   Remove-Item -Recurse -Force "$env:LOCALAPPDATA\Microsoft\WinGet\Packages\jdx.mise_Microsoft.Winget.Source_*" -ErrorAction SilentlyContinue
   ```

3. 재부팅 후 다시 설치:

   ```powershell
   winget install --id jdx.mise -e
   ```

### D) `python`/`node` 버전이 기대와 다를 때

```powershell
mise current
mise which python
rm -r .venv      # (가상환경 버전이 바뀐 경우) 새로 만들고
uv venv --python (mise which python)
uv sync
```

---

## 8) 폴더 구조 & `__init__.py` 규칙

- **코드가 들어가는 모든 폴더**는 Python 패키지로 인식되도록 `__init__.py`(빈 파일 허용)를 둡니다.
- 이유: **오타/상대경로 이슈**를 줄이고, **정적 분석/리팩토링** 도구가 폴더를 명확히 인식하도록 하기 위함.

---

## 9) 팀 운영 원칙(가독성·유지보수성 중심)

- **버전 고정/재현성**: `.mise.toml`/`pyproject.toml`이 소스오브트루스.
- **명령 일관성**: Python 패키지는 **반드시 `uv add/remove`**.
- **문제 발생 시**: `mise current/which`, `uv --version`으로 관측 → 원인(프로필/경로/가상환경)을 분리 진단.
- **문서화**: 변경 시 본 문서를 PR로 업데이트(왜/무엇을/어떻게).

---

### 부록) 왜 이렇게 쓰는가? (짧은 이유)

- **mise**: 언어별 도구를 **단일 문법**으로 관리 → 온보딩/CI 간소화, 레포 이동 시 자동 전환.
- **uv**: `pip/venv` 대비 **속도·재현성 향상**, 락파일 기반 의존성 관리.
- **옵션 A vs B**: 생산성(자동완성) ↔ 안정성(경량)의 **명시적 트레이드오프** 제공.

---
