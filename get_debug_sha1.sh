#!/bin/bash

# Script to get debug SHA-1 certificate for Google Sign-In setup
# This SHA-1 needs to be added to Firebase Console for debug builds to work

echo "=========================================="
echo "Getting Debug SHA-1 Certificate"
echo "=========================================="
echo ""

# Check if keytool is available
if ! command -v keytool &> /dev/null; then
    echo "Error: keytool not found. Make sure Java JDK is installed."
    exit 1
fi

# Get the debug keystore path
if [[ "$OSTYPE" == "darwin"* ]] || [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # macOS or Linux
    DEBUG_KEYSTORE="$HOME/.android/debug.keystore"
else
    # Windows
    DEBUG_KEYSTORE="$USERPROFILE\.android\debug.keystore"
fi

echo "Debug Keystore Location: $DEBUG_KEYSTORE"
echo ""

if [ ! -f "$DEBUG_KEYSTORE" ]; then
    echo "Error: Debug keystore not found at $DEBUG_KEYSTORE"
    echo "Run your app once in debug mode to generate it."
    exit 1
fi

echo "Extracting SHA-1 certificate..."
echo ""

# Extract SHA-1 (password is 'android' for debug keystore)
keytool -list -v -keystore "$DEBUG_KEYSTORE" -alias androiddebugkey -storepass android -keypass android | grep "SHA1:"

echo ""
echo "=========================================="
echo "INSTRUCTIONS:"
echo "=========================================="
echo "1. Copy the SHA1 value above"
echo "2. Go to Firebase Console: https://console.firebase.google.com"
echo "3. Select your project (notester-3be13)"
echo "4. Go to Project Settings > General"
echo "5. Scroll down to 'Your apps' section"
echo "6. Click on your Android app"
echo "7. Click 'Add fingerprint' button"
echo "8. Paste the SHA-1 value"
echo "9. Download the updated google-services.json"
echo "10. Replace android/app/google-services.json with the new file"
echo "11. Run: flutter clean && flutter pub get"
echo "12. Rebuild your app"
echo "=========================================="
