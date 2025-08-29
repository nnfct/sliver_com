#!/bin/bash
set -e

echo "🚀 sliver_com 개발 환경 설정 시작..."
echo ""

# 1. mise 설치 확인 및 자동 설치
echo "📦 Checking mise..."
if ! command -v mise &> /dev/null; then
    echo "❌ mise not found. Installing..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS
        if ! command -v brew &> /dev/null; then
            echo "Installing Homebrew..."
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        fi
        brew install mise
    else
        # Linux
        curl https://mise.run | sh
        echo 'eval "$(~/.local/bin/mise activate bash)"' >> ~/.bashrc
        export PATH="$HOME/.local/bin:$PATH"
    fi
    echo "✅ mise installed successfully!"
else
    echo "✅ mise already installed ($(mise --version))"
fi

# 2. mise 프로젝트 도구 설치
echo "📦 Installing project tools (Python, Node.js, uv)..."
mise install  # Python 3.12, Node.js 22, uv 자동 설치

# 3. yarn 설치 확인 (mise.toml에 없으니 별도 설치)
echo "📦 Checking yarn..."
if ! command -v yarn &> /dev/null; then
    echo "❌ yarn not found. Installing..."
    npm install -g yarn@1.22.22
    echo "✅ yarn installed successfully!"
else
    echo "✅ yarn already installed ($(yarn --version))"
fi

# 4. 버전 확인
echo "🔍 Checking tool versions..."
echo "  Python: $(python --version 2>/dev/null || echo 'Not found')"
echo "  Node.js: $(node --version 2>/dev/null || echo 'Not found')"
echo "  uv: $(uv --version 2>/dev/null || echo 'Not found')"
echo "  yarn: $(yarn --version 2>/dev/null || echo 'Not found')"

# 5. Python 환경 설정
echo "🐍 Setting up Python environment..."
uv sync

# 6. Node.js 환경 설정
echo "📱 Setting up Node.js environment..."
yarn install

# 7. Azure 설정 안내
echo ""
echo "🗄️ Azure 설정이 필요합니다:"
echo "   ✅ Azure Database for PostgreSQL"
echo "   ✅ Azure Cache for Redis"
echo "   ✅ Azure AD B2C (인증)"
echo ""
echo "📖 자세한 설정 방법은 TEAM_GUIDE.md를 참고하세요."

echo ""
echo "✅ 환경 설정 완료!"
echo ""
echo "🚀 개발 서버 실행 방법:"
echo "  전체 실행:   yarn dev"
echo "  API만:       yarn dev:api"
echo "  Web만:       yarn dev:web"
echo "  Mobile만:    yarn dev:mobile"
echo ""
echo "🌐 접속 주소:"
echo "  - Web App: http://localhost:3000"
echo "  - API Docs: http://localhost:8000/docs"
echo "  - Mobile: Expo QR 코드 스캔"