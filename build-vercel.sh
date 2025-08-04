#!/bin/bash
set -e

echo "🚀 Starting Flutter Web Build..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Setup Flutter for web only
flutter config --no-analytics
flutter config --enable-web
flutter precache --web

# Clean previous builds
flutter clean
flutter pub get

# Build web specifically
flutter build web --release --base-href="/"

# Verify build output
if [ ! -f "build/web/index.html" ]; then
  echo "❌ ERROR: build/web/index.html not found!"
  echo "📁 Available files in build/web/:"
  ls -la build/web/ || echo "build/web/ directory doesn't exist"
  exit 1
fi

echo "✅ Build completed successfully"
echo "📁 Build files:"
ls -la build/web/