#!/bin/bash
# Build script for Appetize.io deployment
# This script builds Android APK for Appetize.io

set -e

echo "🔨 Building for Appetize.io..."

# Build Android APK
flutter build apk --release

# Check if build was successful
if [ -f "build/app/outputs/flutter-apk/app-release.apk" ]; then
    echo "✅ Android APK built successfully!"
    echo "📱 APK location: build/app/outputs/flutter-apk/app-release.apk"
    echo ""
    echo "🚀 Ready for Appetize.io deployment:"
    echo "1. Upload the APK file to https://appetize.io/upload"
    echo "2. Or use Appetize.io API with the APK file"
else
    echo "❌ Android APK build failed"
    exit 1
fi

# Optional: Build iOS if running on macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "📱 Building iOS app..."
    flutter build ios --release --no-codesign
    
    # Create .app bundle for Appetize.io
    cd build/ios/iphoneos
    mkdir -p Payload
    cp -R Runner.app Payload/
    zip -r app-release.ipa Payload
    
    echo "✅ iOS IPA built successfully!"
    echo "📱 IPA location: build/ios/iphoneos/app-release.ipa"
fi