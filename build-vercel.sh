#!/bin/bash
set -e

# Install Flutter
git clone https://github.com/flutter/flutter.git -b stable --depth 1
export PATH="$PATH:$(pwd)/flutter/bin"

# Setup Flutter
flutter config --no-analytics
flutter config --enable-web
flutter precache --web

# Build
flutter pub get
flutter build web --release --base-href="/"