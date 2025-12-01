#!/bin/bash

echo "=========================================="
echo "Google Sign-In Setup Verification"
echo "=========================================="
echo ""

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Check 1: google-services.json exists
echo "1. Checking google-services.json..."
if [ -f "android/app/google-services.json" ]; then
    echo -e "${GREEN}✓ google-services.json found${NC}"
    
    # Extract package name
    PACKAGE_NAME=$(grep -o '"package_name": "[^"]*"' android/app/google-services.json | head -1 | cut -d'"' -f4)
    echo "   Package name: $PACKAGE_NAME"
    
    # Count OAuth clients
    OAUTH_COUNT=$(grep -c '"client_type": 1' android/app/google-services.json)
    echo "   OAuth clients configured: $OAUTH_COUNT"
else
    echo -e "${RED}✗ google-services.json NOT found${NC}"
fi
echo ""

# Check 2: Debug keystore exists
echo "2. Checking debug keystore..."
DEBUG_KEYSTORE="$HOME/.android/debug.keystore"
if [ -f "$DEBUG_KEYSTORE" ]; then
    echo -e "${GREEN}✓ Debug keystore found${NC}"
    
    # Get SHA-1
    SHA1=$(keytool -list -v -keystore "$DEBUG_KEYSTORE" -alias androiddebugkey -storepass android -keypass android 2>/dev/null | grep "SHA1:" | cut -d' ' -f3)
    echo "   Your debug SHA-1: $SHA1"
    
    # Check if SHA-1 is in google-services.json
    if grep -q "${SHA1,,}" android/app/google-services.json 2>/dev/null; then
        echo -e "${GREEN}✓ Debug SHA-1 is registered in Firebase${NC}"
    else
        echo -e "${YELLOW}⚠ Debug SHA-1 NOT found in google-services.json${NC}"
        echo -e "${YELLOW}  You need to add it to Firebase Console${NC}"
    fi
else
    echo -e "${YELLOW}⚠ Debug keystore not found${NC}"
    echo "   Run your app once to generate it"
fi
echo ""

# Check 3: Package name in build.gradle
echo "3. Checking package name in build.gradle..."
if [ -f "android/app/build.gradle" ]; then
    BUILD_PACKAGE=$(grep "applicationId" android/app/build.gradle | cut -d'"' -f2)
    echo "   Build package: $BUILD_PACKAGE"
    
    if [ "$BUILD_PACKAGE" == "$PACKAGE_NAME" ]; then
        echo -e "${GREEN}✓ Package names match${NC}"
    else
        echo -e "${RED}✗ Package names DO NOT match${NC}"
    fi
else
    echo -e "${RED}✗ build.gradle not found${NC}"
fi
echo ""

# Check 4: Google Sign-In dependency
echo "4. Checking dependencies..."
if grep -q "google_sign_in:" pubspec.yaml; then
    VERSION=$(grep "google_sign_in:" pubspec.yaml | cut -d'^' -f2)
    echo -e "${GREEN}✓ google_sign_in: ^$VERSION${NC}"
else
    echo -e "${RED}✗ google_sign_in not found in pubspec.yaml${NC}"
fi

if grep -q "firebase_auth:" pubspec.yaml; then
    VERSION=$(grep "firebase_auth:" pubspec.yaml | cut -d'^' -f2)
    echo -e "${GREEN}✓ firebase_auth: ^$VERSION${NC}"
else
    echo -e "${RED}✗ firebase_auth not found in pubspec.yaml${NC}"
fi
echo ""

# Check 5: Google Services plugin
echo "5. Checking Google Services plugin..."
if grep -q "com.google.gms.google-services" android/app/build.gradle; then
    echo -e "${GREEN}✓ Google Services plugin configured${NC}"
else
    echo -e "${RED}✗ Google Services plugin NOT configured${NC}"
fi
echo ""

echo "=========================================="
echo "Summary"
echo "=========================================="
echo ""
echo "If you see any ✗ or ⚠ above, follow these steps:"
echo ""
echo "1. Add your debug SHA-1 to Firebase Console:"
echo "   SHA-1: $SHA1"
echo ""
echo "2. Download updated google-services.json from Firebase"
echo ""
echo "3. Replace android/app/google-services.json"
echo ""
echo "4. Run: flutter clean && flutter pub get"
echo ""
echo "5. Rebuild and test"
echo ""
echo "For detailed instructions, see: GOOGLE_SIGNIN_DEBUG_FIX.md"
echo "=========================================="
