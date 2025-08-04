#!/bin/bash
set -e

echo "🚀 Installing Flutter..."
wget -q https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.24.5-stable.tar.xz
tar xf flutter_linux_3.24.5-stable.tar.xz
export PATH="$PATH:$(pwd)/flutter/bin"

echo "🔧 Setting up Flutter..."
flutter config --no-analytics
flutter config --enable-web
flutter doctor

echo "📦 Installing dependencies..."
flutter pub get

echo "🏗️ Building web..."
flutter build web --release --base-href=/

echo "✅ Build completed!"
ls -la build/web/