# Fix Google Sign-In for Debug Mode

## Problem
Google Sign-In throws `GenericAuthException` in debug mode because the debug SHA-1 certificate is not registered in Firebase Console.

## Solution

### Step 1: Get Your Debug SHA-1 Certificate

#### Option A: Using the provided script (macOS/Linux)
```bash
./get_debug_sha1.sh
```

#### Option B: Manual command
```bash
# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android

# Windows
keytool -list -v -keystore %USERPROFILE%\.android\debug.keystore -alias androiddebugkey -storepass android -keypass android
```

Look for the line that says `SHA1:` and copy the value (e.g., `SHA1: 12:34:56:78:90:AB:CD:EF:...`)

### Step 2: Add SHA-1 to Firebase Console

1. Go to [Firebase Console](https://console.firebase.google.com)
2. Select your project: **notester-3be13**
3. Click the gear icon ⚙️ > **Project Settings**
4. Scroll down to **Your apps** section
5. Find your Android app (`com.rojanshr.notester`)
6. Click **Add fingerprint** button
7. Paste your debug SHA-1 certificate
8. Click **Save**

### Step 3: Download Updated google-services.json

1. In the same Firebase Console page
2. Click **Download google-services.json**
3. Replace `android/app/google-services.json` with the new file

### Step 4: Clean and Rebuild

```bash
flutter clean
flutter pub get
flutter run
```

## Additional Configuration (Already Done)

The following configurations are already in place:

### AndroidManifest.xml
The app already has internet permissions configured.

### build.gradle
Google Services plugin is already configured.

### pubspec.yaml
```yaml
google_sign_in: ^6.3.0
firebase_auth: ^5.7.0
firebase_core: ^3.15.2
```

## Testing

After completing the steps above:

1. Run the app in debug mode
2. Tap the Google Sign-In button
3. Select a Google account
4. Sign-in should complete successfully

## Common Issues

### Issue: "PlatformException(sign_in_failed)"
**Solution**: Make sure you added the debug SHA-1 to Firebase Console and downloaded the updated google-services.json

### Issue: "Error 10: Developer console is not set up correctly"
**Solution**: 
- Verify the package name matches: `com.rojanshr.notester`
- Ensure SHA-1 is added correctly
- Wait a few minutes for Firebase to propagate changes

### Issue: Still getting GenericAuthException
**Solution**:
1. Check the debug console for specific error messages
2. Verify google-services.json is in `android/app/` directory
3. Run `flutter clean` and rebuild
4. Check that Google Sign-In is enabled in Firebase Console > Authentication > Sign-in method

## For Release Builds

For release builds, you'll need to add the release SHA-1 certificate:

```bash
keytool -list -v -keystore android/notester-upload-keystore.jks -alias upload
```

Then add this SHA-1 to Firebase Console following the same steps above.

## Current SHA-1 Certificates in Firebase

Your Firebase project currently has these SHA-1 certificates registered:
- `3048cf313a564fc1e831028580cad162df65e252`
- `21f48892fb23ee3f6759a9252555d40d36305e5a`
- `49ffbd6af1ed5569817bef29a5b3b0266cf6d6ff`
- `d302b7f33a8943ca9fe29c29506083fc9c41bbab`
- `2e9a16a37a62c94543ec1cd3c3ab8aa8f3ad7a65`

If your debug SHA-1 is not in this list, you need to add it.
