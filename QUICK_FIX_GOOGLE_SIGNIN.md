# Quick Fix: Google Sign-In Debug Mode

## Your Debug SHA-1 Certificate
```
DA:76:18:2D:4A:CB:2E:7A:D4:C8:B8:6C:0E:FE:DD:5C:DE:B0:44:F4
```

## Quick Steps to Fix

### 1. Add SHA-1 to Firebase (2 minutes)
1. Open: https://console.firebase.google.com/project/notester-3be13/settings/general
2. Scroll to "Your apps" → Find Android app
3. Click "Add fingerprint"
4. Paste: `DA:76:18:2D:4A:CB:2E:7A:D4:C8:B8:6C:0E:FE:DD:5C:DE:B0:44:F4`
5. Click "Save"

### 2. Download Updated Config
1. On the same page, click "Download google-services.json"
2. Replace `android/app/google-services.json` with the downloaded file

### 3. Clean & Rebuild
```bash
flutter clean
flutter pub get
flutter run
```

## What Was Fixed

### Code Changes
- ✅ Updated `auth_services.dart` with better error handling
- ✅ Added sign-out before sign-in to ensure clean state
- ✅ Added null checks for tokens
- ✅ Added debug logging for troubleshooting

### Configuration
- ✅ Gradle 8.3 with AGP 8.1.4
- ✅ google_sign_in: ^6.3.0
- ✅ firebase_auth: ^5.7.0
- ✅ Google Services plugin configured

## Testing
After completing the steps:
1. Run the app
2. Tap Google Sign-In button
3. Select a Google account
4. Should sign in successfully ✅

## Still Having Issues?

Run the verification script:
```bash
./verify_google_signin_setup.sh
```

Check detailed guide:
```bash
cat GOOGLE_SIGNIN_DEBUG_FIX.md
```

## Common Errors & Solutions

| Error | Solution |
|-------|----------|
| `GenericAuthException` | Add debug SHA-1 to Firebase |
| `PlatformException(sign_in_failed)` | Download updated google-services.json |
| `Error 10` | Verify package name matches |
| User cancelled | Normal behavior, not an error |

## Need Help?
Check the console logs - the updated code now prints specific error messages to help debug.
