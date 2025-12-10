# Notester 📝

A comprehensive note-taking and productivity application built with Flutter, featuring cloud synchronization, multimedia support, and advanced organizational tools.

## 🚀 Features

### 📋 Core Functionality
- **Rich Text Notes**: Create and edit notes with full text formatting
- **Cloud Synchronization**: Real-time sync across devices using Firebase
- **Multimedia Support**: Attach images and files to your notes
- **PDF Export**: Convert notes to PDF format for sharing and archiving
- **Scratch Pad**: Digital drawing canvas with various tools and colors
- **To-Do Lists**: Create and manage interactive checklists with progress tracking

### 🎨 User Experience
- **Dark/Light Theme**: Automatic theme switching with user preferences
- **Favorites System**: Mark important notes and checklists as favorites
- **Search & Filter**: Quickly find notes with advanced filtering options
- **Pull-to-Refresh**: Refresh content with intuitive pull gestures
- **Responsive Design**: Optimized for various screen sizes and orientations

### 🔐 Authentication & Security
- **Google Sign-In**: Secure authentication with Google accounts
- **Firebase Auth**: Robust user management and security
- **Cloud Storage**: Secure file and image storage with Firebase Storage

### 📱 Platform Support
- **Android**: Full native Android support
- **iOS**: Complete iOS integration
- **Cross-Platform**: Consistent experience across platforms

## 🛠️ Technical Specifications

### Flutter Version
- **Flutter SDK**: `>=3.0.0 <4.0.0`
- **Dart SDK**: `>=3.0.0 <4.0.0`

### Key Dependencies
- **State Management**: `flutter_bloc ^8.1.6`, `provider ^6.1.5`
- **Firebase**: `firebase_core ^3.15.2`, `firebase_auth ^5.7.0`, `cloud_firestore ^5.6.12`
- **UI/UX**: `flutter_screenutil ^5.9.3`, `cached_network_image ^3.4.1`
- **File Handling**: `file_picker ^8.3.7`, `image_picker ^0.8.9`, `path_provider ^2.1.5`
- **PDF Generation**: `pdf ^3.11.1`, `printing ^5.13.4`
- **Drawing**: `scribble ^0.10.0`, `screenshot ^3.0.0`
- **Permissions**: `permission_handler ^11.3.1`

## 📦 Installation

### Prerequisites
1. **Flutter SDK**: Install Flutter 3.0.0 or higher
   ```bash
   flutter --version
   ```

2. **Development Environment**: 
   - Android Studio / VS Code with Flutter extensions
   - Xcode (for iOS development on macOS)

3. **Firebase Setup**: 
   - Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
   - Enable Authentication, Firestore, and Storage services

### Setup Instructions

#### 1. Clone the Repository
```bash
git clone <repository-url>
cd notester
```

#### 2. Install Dependencies
```bash
flutter pub get
```

#### 3. Firebase Configuration

**Android Setup:**
1. Download `google-services.json` from Firebase Console
2. Place it in `android/app/` directory

**iOS Setup:**
1. Download `GoogleService-Info.plist` from Firebase Console  
2. Add it to the iOS project in Xcode

#### 4. Generate SHA-1 Certificate (Android)
```bash
# For debug builds
./get_debug_sha1.sh

# Add the SHA-1 fingerprint to Firebase Console
```

#### 5. Configure Google Sign-In
Run the verification script to ensure proper setup:
```bash
./verify_google_signin_setup.sh
```

#### 6. Generate App Icons
```bash
flutter pub run flutter_launcher_icons:main
```

#### 7. Run the Application
```bash
# Debug mode
flutter run

# Release mode
flutter run --release
```

## 🏗️ Project Structure

```
lib/
├── cubit/              # State management (BLoC/Cubit)
├── model/              # Data models
├── provider/           # Provider classes
├── services/           # Business logic and API services
│   ├── auth_services.dart
│   ├── cloud/          # Firebase services
│   └── fcm_services.dart
├── utils/              # Utilities and constants
├── view/               # UI screens and widgets
│   ├── notes/          # Notes functionality
│   ├── checklists/     # To-do lists
│   ├── scratchpad/     # Drawing canvas
│   └── settings/       # App settings
└── widgets/            # Reusable UI components
```

## 🔧 Configuration

### Environment Variables
Create necessary configuration files for:
- Firebase configuration
- API keys (if applicable)
- Build configurations

### Permissions
The app requires the following permissions:
- **Storage**: For saving files and images
- **Camera**: For taking photos
- **Internet**: For cloud synchronization

## 🚀 Building for Production

### Android
```bash
# Build APK
flutter build apk --release

# Build App Bundle (recommended for Play Store)
flutter build appbundle --release
```

### iOS
```bash
# Build for iOS
flutter build ios --release
```

## 🧪 Testing

Run the test suite:
```bash
# Unit tests
flutter test

# Integration tests (if available)
flutter test integration_test/
```

## 📱 Features in Detail

### Notes Management
- Create, edit, and delete notes
- Rich text formatting
- Image and file attachments
- Cloud synchronization
- Favorite marking
- PDF export functionality

### Checklist System
- Interactive to-do lists
- Progress tracking
- Completion statistics
- Grid-based layout
- Real-time updates

### Scratch Pad
- Digital drawing canvas
- Multiple brush sizes and colors
- Undo/redo functionality
- Save drawings to gallery
- Eraser tool

### User Settings
- Theme preferences
- Account management
- Data synchronization settings
- App preferences

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For support and questions:
- Create an issue in the repository
- Check existing documentation files in the project
- Review Firebase setup guides

## 📋 Version History

- **v2.1.1+8**: Current version with latest features and improvements
- Enhanced UI/UX
- Improved performance and stability
- Bug fixes and optimizations

---

**Built with ❤️ using Flutter**