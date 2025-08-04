#!/bin/bash
set -e

echo "🚀 Starting Minimal Flutter Web Build..."

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Setup Flutter
flutter config --no-analytics
flutter config --enable-web

# Build
flutter pub get
flutter build web --release --base-href="/"

# Check if build succeeded
if [ -d "build/web" ] && [ -f "build/web/index.html" ]; then
    echo "✅ Build completed successfully"
    ls -la build/web/
else
    echo "❌ Build failed - web directory or index.html not found"
    exit 1
fi