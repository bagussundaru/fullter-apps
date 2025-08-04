# Flutter Web Deployment Guide

## Vercel Deployment - Troubleshooting 404 NOT_FOUND

### Common Causes & Solutions

#### 1. **Build Output Directory Issue**
- **Problem**: Vercel can't find the built web files
- **Solution**: Ensure `build/web` directory exists after build

#### 2. **Missing vercel.json Configuration**
- **Problem**: Vercel doesn't know how to handle Flutter web builds
- **Solution**: Use the provided `vercel.json` file

#### 3. **Base Href Configuration**
- **Problem**: Assets not loading due to incorrect base path
- **Solution**: Ensure `web/index.html` has correct base href

### Step-by-Step Deployment

#### Method 1: Vercel CLI
```bash
# Install Vercel CLI
npm i -g vercel

# Deploy from project root
vercel --prod

# Or with specific settings
vercel --prod --build-env FLUTTER_BASE_HREF="/"
```

#### Method 2: GitHub Integration
1. Push code to GitHub
2. Import project in Vercel dashboard
3. Set build command: `curl -o flutter.tar.xz https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.29.2-stable.tar.xz && tar xf flutter.tar.xz && export PATH="$PATH:$(pwd)/flutter/bin" && flutter doctor && flutter config --enable-web && flutter pub get && flutter build web --release`
4. Set output directory: `build/web`
5. Deploy

#### Method 3: Manual Build & Deploy
```bash
# Build locally
flutter build web --release

# Deploy build/web folder
vercel --prod build/web
```

### Troubleshooting 404 Errors

#### Check 1: Verify Build Success
```bash
flutter build web --release
ls -la build/web/
```

#### Check 2: Test Local Server
```bash
# Test locally
cd build/web
python -m http.server 8080
# Navigate to http://localhost:8080
```

#### Check 3: Vercel Build Logs
- Check Vercel dashboard build logs
- Look for Flutter installation issues
- Verify build command execution

### Environment Variables

Add these to Vercel environment variables:
- `FLUTTER_BASE_HREF`: "/" (for root deployment)
- `FLUTTER_WEB_USE_SKIA`: "true" (for better performance)

### Alternative Build Configuration

If the current vercel.json doesn't work, try this simplified version:

```json
{
  "version": 2,
  "buildCommand": "flutter build web --release",
  "outputDirectory": "build/web",
  "routes": [
    {
      "src": "/(.*)",
      "dest": "/index.html"
    }
  ]
}
```

### Flutter Doctor Check

Before deployment, ensure:
```bash
flutter doctor
flutter config --enable-web
```

### Common Fixes

1. **Clear Vercel Cache**: `vercel --prod --force`
2. **Check Dependencies**: Ensure all packages support web
3. **Asset Loading**: Verify assets are in `pubspec.yaml`
4. **Routing**: Use hash routing if SPA routing fails

### Support

If issues persist:
1. Check Vercel deployment logs
2. Verify Flutter web build locally
3. Test with minimal Flutter app first
4. Check browser developer tools for asset loading errors