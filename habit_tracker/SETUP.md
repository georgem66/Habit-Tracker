# Habit Tracker - Setup Guide

This comprehensive guide will help you set up and run the Habit Tracker Flutter application on your device.

## Table of Contents
- [Prerequisites](#prerequisites)
- [System Requirements](#system-requirements)
- [Installation Steps](#installation-steps)
- [Firebase Configuration](#firebase-configuration)
- [Platform-Specific Setup](#platform-specific-setup)
- [Running the Application](#running-the-application)
- [Troubleshooting](#troubleshooting)

## Prerequisites

### Required Software

1. **Flutter SDK** (Version 3.0.0 or higher)
   - Download from: https://docs.flutter.dev/get-started/install
   - Follow platform-specific installation instructions
   - Required Dart SDK: >=3.0.0 <4.0.0

2. **Git**
   - Download from: https://git-scm.com/downloads
   - Required for cloning the repository

3. **IDE (Choose one)**
   - **Visual Studio Code** (Recommended)
     - Download: https://code.visualstudio.com/
     - Install Flutter extension
     - Install Dart extension
   - **Android Studio**
     - Download: https://developer.android.com/studio
     - Install Flutter plugin
     - Install Dart plugin

4. **Firebase Account**
   - Sign up at: https://firebase.google.com/
   - Required for authentication and database features

## System Requirements

### For Android Development

1. **Android Studio** or **Android SDK Command-line Tools**
   - Minimum Android SDK: API 21 (Android 5.0 Lollipop)
   - Target Android SDK: API 34 or higher
   - Build tools version: Latest

2. **Java Development Kit (JDK)**
   - JDK 17 or higher
   - Download: https://www.oracle.com/java/technologies/downloads/

3. **Android Device or Emulator**
   - Physical device with USB debugging enabled, OR
   - Android Virtual Device (AVD) set up in Android Studio

### For iOS Development (macOS only)

1. **Xcode** (Latest stable version)
   - Download from Mac App Store
   - Minimum version: 14.0

2. **CocoaPods**
   - Install via terminal: `sudo gem install cocoapods`

3. **iOS Device or Simulator**
   - Physical device with developer mode enabled, OR
   - iOS Simulator (included with Xcode)

### For Windows Development

1. **Visual Studio 2022** (For Windows desktop apps)
   - Download: https://visualstudio.microsoft.com/downloads/
   - Install "Desktop development with C++" workload

### For Linux Development

1. **Required libraries**
   ```bash
   sudo apt-get update
   sudo apt-get install clang cmake ninja-build pkg-config libgtk-3-dev
   ```

### For Web Development

1. **Modern Web Browser**
   - Chrome (Recommended for debugging)
   - Firefox
   - Safari
   - Edge

## Installation Steps

### 1. Install Flutter

**Windows:**
```bash
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/windows
# Extract the zip file to desired location (e.g., C:\src\flutter)
# Add Flutter to PATH: C:\src\flutter\bin

# Verify installation
flutter --version
flutter doctor
```

**macOS:**
```bash
# Download Flutter SDK from https://docs.flutter.dev/get-started/install/macos
# Extract to desired location
cd ~/development
unzip ~/Downloads/flutter_macos_*.zip

# Add to PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="$PATH:$HOME/development/flutter/bin"

# Verify installation
flutter --version
flutter doctor
```

**Linux:**
```bash
# Download Flutter SDK
cd ~
wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_*-stable.tar.xz

# Extract
tar xf flutter_linux_*-stable.tar.xz

# Add to PATH (add to ~/.bashrc or ~/.zshrc)
export PATH="$PATH:$HOME/flutter/bin"

# Verify installation
flutter --version
flutter doctor
```

### 2. Run Flutter Doctor

After installing Flutter, run the following command to check your environment:

```bash
flutter doctor
```

This command will show you what needs to be installed or configured. Follow the instructions to resolve any issues marked with ❌.

### 3. Clone the Repository

```bash
git clone https://github.com/georgem66/Habit-Tracker.git
cd Habit-Tracker/habit_tracker
```

### 4. Install Dependencies

```bash
flutter pub get
```

This will download all the required packages listed in `pubspec.yaml`.

## Firebase Configuration

### 1. Create a Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project"
3. Follow the setup wizard
4. Enable Google Analytics (optional)

### 2. Set Up Firebase Authentication

1. In Firebase Console, go to **Authentication**
2. Click **Get Started**
3. Enable the following sign-in methods:
   - **Email/Password**: Enable this provider
   - **Google**: Enable and configure OAuth 2.0

### 3. Set Up Cloud Firestore

1. In Firebase Console, go to **Firestore Database**
2. Click **Create Database**
3. Start in **Test Mode** (for development) or **Production Mode** (for production)
4. Choose a location for your database
5. Set up the following security rules (can be updated later):

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users collection
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Habits collection
    match /habits/{habitId} {
      allow read, write: if request.auth != null;
    }
  }
}
```

### 4. Configure Firebase for Each Platform

#### Android Configuration

1. In Firebase Console, add an Android app:
   - Click **Add app** → **Android**
   - Package name: `com.example.habit_tracker`
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`

2. Ensure `android/app/build.gradle.kts` has:
   ```kotlin
   plugins {
       id("com.android.application")
       id("kotlin-android")
       id("com.google.gms.google-services")  // Add this line
   }
   ```

3. Ensure `android/build.gradle.kts` has:
   ```kotlin
   dependencies {
       classpath("com.google.gms:google-services:4.4.0")
   }
   ```

#### iOS Configuration

1. In Firebase Console, add an iOS app:
   - Click **Add app** → **iOS**
   - Bundle ID: `com.example.habitTracker`
   - Download `GoogleService-Info.plist`
   - Open Xcode: `open ios/Runner.xcworkspace`
   - Drag `GoogleService-Info.plist` into the `Runner` folder in Xcode

2. Update `ios/Runner/Info.plist` with required permissions:
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
       <dict>
           <key>CFBundleTypeRole</key>
           <string>Editor</string>
           <key>CFBundleURLSchemes</key>
           <array>
               <string>com.googleusercontent.apps.YOUR-CLIENT-ID</string>
           </array>
       </dict>
   </array>
   ```

#### Web Configuration

1. In Firebase Console, add a Web app:
   - Click **Add app** → **Web**
   - Register the app
   - Copy the Firebase configuration

2. Update `web/index.html` with Firebase configuration:
   ```html
   <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-auth-compat.js"></script>
   <script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
   <script>
     const firebaseConfig = {
       apiKey: "YOUR-API-KEY",
       authDomain: "YOUR-AUTH-DOMAIN",
       projectId: "YOUR-PROJECT-ID",
       storageBucket: "YOUR-STORAGE-BUCKET",
       messagingSenderId: "YOUR-MESSAGING-SENDER-ID",
       appId: "YOUR-APP-ID"
     };
     firebase.initializeApp(firebaseConfig);
   </script>
   ```

### 5. Google Sign-In Configuration

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Select your Firebase project
3. Go to **APIs & Services** → **Credentials**
4. Configure OAuth consent screen
5. Create OAuth 2.0 Client IDs for each platform:
   - **Android**: Use SHA-1 fingerprint from your keystore
   - **iOS**: Use bundle ID
   - **Web**: Add authorized domains

## Platform-Specific Setup

### Android Setup

1. **Get SHA-1 Fingerprint** (for Google Sign-In):
   ```bash
   # For debug keystore
   cd android
   ./gradlew signingReport
   
   # Or use keytool
   keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
   ```

2. **Add SHA-1 to Firebase**:
   - Go to Firebase Console → Project Settings → Your Android App
   - Add the SHA-1 fingerprint

3. **Enable Multidex** (if app size is large):
   - Already configured in `android/app/build.gradle.kts`

### iOS Setup (macOS only)

1. **Install CocoaPods dependencies**:
   ```bash
   cd ios
   pod install
   cd ..
   ```

2. **Update Minimum iOS Version**:
   - Open `ios/Podfile`
   - Ensure: `platform :ios, '12.0'` or higher

3. **Code Signing**:
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select Runner → Signing & Capabilities
   - Select your Team
   - Ensure Bundle Identifier is correct

### Web Setup

1. **Enable CORS** (if needed for API calls):
   - Configure in your backend or Firebase

2. **Update Firebase Hosting** (optional):
   ```bash
   flutter build web
   firebase init hosting
   firebase deploy
   ```

## Running the Application

### Run on Android

1. **Connect Android device** or **start emulator**:
   ```bash
   flutter emulators --launch <emulator_id>
   ```

2. **Run the app**:
   ```bash
   flutter run
   # Or specify device
   flutter run -d <device_id>
   ```

### Run on iOS (macOS only)

1. **Open iOS Simulator**:
   ```bash
   open -a Simulator
   ```

2. **Run the app**:
   ```bash
   flutter run
   # Or specify device
   flutter run -d <device_id>
   ```

### Run on Web

```bash
flutter run -d chrome
# Or
flutter run -d web-server
```

### Run on Windows

```bash
flutter run -d windows
```

### Run on Linux

```bash
flutter run -d linux
```

### List Available Devices

```bash
flutter devices
```

## Development Commands

### Useful Flutter Commands

```bash
# Get dependencies
flutter pub get

# Clean build artifacts
flutter clean

# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Build release APK (Android)
flutter build apk --release

# Build release bundle (Android)
flutter build appbundle --release

# Build iOS (macOS only)
flutter build ios --release

# Build web
flutter build web

# Check for outdated packages
flutter pub outdated

# Upgrade packages
flutter pub upgrade
```

## Required Assets

The app requires the following assets:

1. **Images**: Place in `assets/images/` directory
2. **quotes.json**: Place in `assets/` directory

Example `assets/quotes.json` structure:
```json
{
  "quotes": [
    {
      "text": "The secret of getting ahead is getting started.",
      "author": "Mark Twain"
    },
    {
      "text": "Success is the sum of small efforts repeated day in and day out.",
      "author": "Robert Collier"
    }
  ]
}
```

## Troubleshooting

### Common Issues

#### 1. Flutter Doctor Issues

**Problem**: Android licenses not accepted
```bash
flutter doctor --android-licenses
```

**Problem**: Xcode not configured
```bash
sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
sudo xcodebuild -runFirstLaunch
```

#### 2. Dependency Issues

```bash
# Clear pub cache
flutter pub cache repair

# Clean and get dependencies
flutter clean
flutter pub get
```

#### 3. Firebase Issues

**Problem**: Firebase not initialized
- Ensure Firebase configuration files are in the correct location
- Check that Firebase dependencies are properly installed
- Verify Firebase project settings

**Problem**: Google Sign-In not working
- Verify SHA-1 fingerprints in Firebase Console
- Check OAuth 2.0 Client IDs in Google Cloud Console
- Ensure support email is set in OAuth consent screen

#### 4. Build Issues

**Android Gradle Issues**:
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

**iOS Build Issues**:
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

#### 5. Hot Reload Not Working

```bash
# Press 'R' in terminal to hot reload
# Press 'Shift+R' to hot restart
# Or use IDE buttons
```

### Getting Help

- **Flutter Documentation**: https://docs.flutter.dev/
- **Firebase Documentation**: https://firebase.google.com/docs
- **Stack Overflow**: https://stackoverflow.com/questions/tagged/flutter
- **Flutter Community**: https://flutter.dev/community
- **GitHub Issues**: https://github.com/georgem66/Habit-Tracker/issues

## Environment Variables (Optional)

For production builds, consider using environment variables or build flavors:

1. Create different Firebase projects for dev/staging/prod
2. Use build flavors to switch between environments
3. Store sensitive data in environment variables

## Performance Optimization

For better app performance:

1. **Enable R8/ProGuard** for Android (already enabled in release builds)
2. **Use const constructors** where possible
3. **Lazy load** images and data
4. **Implement pagination** for large data sets
5. **Use cached network images**

## Security Best Practices

1. **Never commit** Firebase configuration files with real credentials to public repos
2. **Enable App Check** in Firebase for production
3. **Use environment-specific** Firebase projects
4. **Implement proper** Firestore security rules
5. **Store sensitive data** securely using flutter_secure_storage

## Next Steps

1. ✅ Install Flutter SDK and required tools
2. ✅ Set up IDE with Flutter/Dart plugins
3. ✅ Clone the repository
4. ✅ Configure Firebase for your platforms
5. ✅ Add Firebase configuration files
6. ✅ Run `flutter pub get`
7. ✅ Run the app on your device/emulator
8. ✅ Test authentication and features
9. ✅ Customize the app as needed
10. ✅ Deploy to production when ready

## Project Structure

```
habit_tracker/
├── android/          # Android-specific code
├── ios/             # iOS-specific code
├── lib/             # Dart source code
│   ├── exceptions/  # Custom exceptions
│   ├── models/      # Data models
│   ├── screens/     # UI screens
│   ├── services/    # Business logic & services
│   ├── widgets/     # Reusable widgets
│   └── main.dart    # App entry point
├── linux/           # Linux-specific code
├── macos/           # macOS-specific code
├── web/             # Web-specific code
├── windows/         # Windows-specific code
├── assets/          # Images, fonts, etc.
├── test/            # Unit and widget tests
└── pubspec.yaml     # Dependencies
```

## Support

For additional help or questions:
- Review the Flutter documentation
- Check existing GitHub issues
- Create a new issue with detailed information
- Join Flutter community forums

---

**Version**: 1.0.0  
**Last Updated**: February 2026  
**Maintained By**: Habit Tracker Team
