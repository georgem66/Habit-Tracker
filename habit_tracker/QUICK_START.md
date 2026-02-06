# Quick Start Guide

Get the Habit Tracker app running in 5 minutes!

## ⚡ Super Quick Setup (For Experienced Flutter Developers)

```bash
# 1. Clone and navigate
git clone https://github.com/georgem66/Habit-Tracker.git
cd Habit-Tracker/habit_tracker

# 2. Install dependencies
flutter pub get

# 3. Set up Firebase (required!)
# - Create project at https://console.firebase.google.com/
# - Enable Authentication (Email/Password + Google)
# - Create Firestore database
# - Download config files:
#   Android: google-services.json → android/app/
#   iOS: GoogleService-Info.plist → ios/Runner/
#   Web: Update web/index.html with config

# 4. Run the app
flutter run
```

## 📱 Minimum Requirements

- **Flutter**: 3.0.0+
- **Dart**: 3.0.0+
- **Firebase**: Free account
- **Platform**: Android 5.0+ / iOS 12.0+ / Modern browser

## 🔥 Firebase Setup (Essential!)

### 1. Create Firebase Project
1. Visit [Firebase Console](https://console.firebase.google.com/)
2. Click "Add Project" → Follow wizard
3. Project created ✅

### 2. Enable Authentication
1. Go to **Authentication** → **Get Started**
2. Enable **Email/Password**
3. Enable **Google** sign-in
4. Done ✅

### 3. Create Firestore Database
1. Go to **Firestore Database** → **Create Database**
2. Choose **Test Mode** (for development)
3. Select location
4. Database ready ✅

### 4. Add Platform Configuration

#### Android
```bash
# In Firebase Console → Project Settings → Add Android App
# Package: com.example.habit_tracker
# Download google-services.json
mv ~/Downloads/google-services.json android/app/
```

#### iOS (macOS only)
```bash
# In Firebase Console → Project Settings → Add iOS App
# Bundle ID: com.example.habitTracker
# Download GoogleService-Info.plist
# Open Xcode and drag file to ios/Runner/
open ios/Runner.xcworkspace
```

#### Web
Add to `web/index.html` before `</body>`:
```html
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-auth-compat.js"></script>
<script src="https://www.gstatic.com/firebasejs/10.7.0/firebase-firestore-compat.js"></script>
<script>
  firebase.initializeApp({
    apiKey: "YOUR_API_KEY",
    authDomain: "YOUR_PROJECT.firebaseapp.com",
    projectId: "YOUR_PROJECT_ID",
    storageBucket: "YOUR_PROJECT.appspot.com",
    messagingSenderId: "YOUR_SENDER_ID",
    appId: "YOUR_APP_ID"
  });
</script>
```

## 🚀 Run Commands

```bash
# Check available devices
flutter devices

# Run on Chrome
flutter run -d chrome

# Run on Android
flutter run -d <android-device-id>

# Run on iOS (macOS only)
flutter run -d <ios-device-id>

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
# Quit: Press 'q' in terminal
```

## 🔍 Troubleshooting

### "Firebase not initialized" error
- ✅ Check config files are in correct locations
- ✅ Run `flutter clean && flutter pub get`
- ✅ Rebuild the app

### Build errors
```bash
# Clean and rebuild
flutter clean
flutter pub get
flutter run
```

### Android build issues
```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
```

### iOS build issues (macOS only)
```bash
cd ios
pod deintegrate
pod install
cd ..
flutter clean
flutter pub get
```

## 📚 Next Steps

- ✅ App running? Test login with email/password
- ✅ Create your first habit
- ✅ Complete it and see your streak!
- ✅ Check out profile and premium features

## 🆘 Need Help?

- **Full Setup Guide**: See [SETUP.md](SETUP.md)
- **Flutter Docs**: https://docs.flutter.dev/
- **Firebase Docs**: https://firebase.google.com/docs
- **Issues**: https://github.com/georgem66/Habit-Tracker/issues

## 💡 Tips

1. **Use Chrome for web development** - Best debugging tools
2. **Enable hot reload** - Fastest development workflow
3. **Test on real device** - Better performance testing
4. **Check logs** - Use `flutter logs` for debugging

## ✅ Verification Checklist

Before reporting issues, verify:
- [ ] Flutter installed (`flutter --version`)
- [ ] Dependencies installed (`flutter pub get`)
- [ ] Firebase project created
- [ ] Authentication enabled in Firebase
- [ ] Firestore database created
- [ ] Config files in correct locations
- [ ] Device/emulator available (`flutter devices`)

---

**Need more details?** Check the comprehensive [SETUP.md](SETUP.md) guide!
