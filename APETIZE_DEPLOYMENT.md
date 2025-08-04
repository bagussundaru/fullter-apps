# Deploy ke Appetize.io - Panduan Lengkap

Appetize.io memungkinkan Anda menjalankan aplikasi mobile Flutter (Android/iOS) langsung di browser tanpa perlu installasi.

## Persiapan

### 1. Build APK Android
```bash
# Jalankan script build khusus Appetize
./deploy-appetize.sh

# Atau build manual
flutter build apk --release
```

File APK akan tersedia di: `build/app/outputs/flutter-apk/app-release.apk`

### 2. Upload ke Appetize.io

#### Cara 1: Upload Manual
1. Buka https://appetize.io/upload
2. Login/signup akun Appetize.io
3. Upload file `app-release.apk`
4. Dapatkan link untuk dibagikan

#### Cara 2: Upload via API (Opsional)
```bash
curl -X POST \
  -H "Authorization: Bearer YOUR_API_KEY" \
  -F "file=@build/app/outputs/flutter-apk/app-release.apk" \
  https://api.appetize.io/v1/apps
```

## Konfigurasi Tambahan untuk Flutter

### Update pubspec.yaml
Pastikan tidak ada plugin yang tidak kompatibel dengan Appetize:

```yaml
# Tambahkan konfigurasi untuk Appetize
flutter:
  assets:
    - assets/images/
  
# Plugin yang aman untuk Appetize
dependencies:
  flutter:
    sdk: flutter
  # Hindari plugin yang membutuhkan hardware khusus
```

### Build Configuration

#### Android (build.gradle)
Pastikan minimum SDK sesuai:
```gradle
android {
    defaultConfig {
        minSdkVersion 21
        targetSdkVersion 34
    }
}
```

## Troubleshooting

### Error Build Android
- **Error: "No Android SDK found"** → Install Android Studio dan setup Android SDK
- **Error: "Keystore not found"** → Gunakan debug keystore atau buat keystore baru

### Error di Appetize.io
- **App crash saat dibuka** → Cek plugin yang tidak kompatibel dengan emulator
- **Network error** → Pastikan app tidak membutuhkan internet khusus

## Tips Optimasi untuk Appetize.io

1. **Ukuran APK**: Semakin kecil APK, semakin cepat load di browser
2. **Assets**: Kompres gambar dan assets
3. **Plugin**: Hapus plugin yang tidak perlu
4. **Testing**: Test dulu di emulator lokal sebelum upload

## Command Build Cepat

```bash
# Build dan upload (Windows PowerShell)
flutter build apk --release
# File APK ada di: build\app\outputs\flutter-apk\app-release.apk

# Build untuk iOS (hanya di macOS)
flutter build ios --release --no-codesign
```

## Link Hasil Deploy

Setelah upload berhasil, Anda akan mendapatkan link seperti:
```
https://appetize.io/embed/YOUR_APP_ID
```

Link ini bisa langsung dibagikan atau di-embed di website.