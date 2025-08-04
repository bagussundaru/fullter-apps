#!/bin/bash

# Install Flutter if not available
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable --depth 1
    export PATH="$PATH:$(pwd)/flutter/bin"
fi

# Verify Flutter installation
flutter --version

# Get dependencies
flutter pub get

# Build web
flutter build web --release --dart-define=FLUTTER_WEB_USE_SKIA=true

# Copy web build to output
cp -r build/web/* .vercel/output/static/ 2>/dev/null || cp -r build/web/* .