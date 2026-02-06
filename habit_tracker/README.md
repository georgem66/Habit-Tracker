# Habit Tracker

A comprehensive habit tracking application built with Flutter and Firebase. Track your daily habits, maintain streaks, earn rewards, and stay motivated with inspirational quotes!

## 🚀 Features

- **User Authentication**: Secure login with Email/Password and Google Sign-In
- **Habit Management**: Create, track, and manage multiple habits
- **Streak Tracking**: Maintain daily streaks and see your progress
- **Rewards System**: Earn points for completing habits consistently
- **Daily Quotes**: Get motivated with inspirational quotes
- **Premium Features**: Unlock unlimited habits and advanced features
- **Cross-Platform**: Runs on Android, iOS, Web, Windows, Linux, and macOS
- **Cloud Sync**: All data synced across devices via Firebase Firestore
- **Beautiful UI**: Modern Material Design 3 interface

## 📱 Screenshots

*Coming soon*

## 🛠️ Technology Stack

- **Framework**: Flutter 3.0+
- **Language**: Dart 3.0+
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore
  - Firebase Storage (optional)
- **State Management**: Provider
- **Local Storage**: Shared Preferences
- **Notifications**: Flutter Local Notifications
- **UI Components**: Material Design 3

## 📋 Prerequisites

Before you begin, ensure you have the following installed:

- Flutter SDK (3.0.0 or higher)
- Dart SDK (3.0.0 or higher)
- Git
- An IDE (VS Code or Android Studio recommended)
- Firebase account (free)

For platform-specific requirements:
- **Android**: Android Studio, JDK 17+
- **iOS**: Xcode 14+ (macOS only)
- **Web**: Modern web browser
- **Desktop**: Platform-specific build tools

## 🚀 Quick Start

### 1. Clone the Repository

```bash
git clone https://github.com/georgem66/Habit-Tracker.git
cd Habit-Tracker/habit_tracker
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Set Up Firebase

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable Authentication (Email/Password and Google Sign-In)
3. Create a Cloud Firestore database
4. Download configuration files:
   - **Android**: `google-services.json` → `android/app/`
   - **iOS**: `GoogleService-Info.plist` → `ios/Runner/`
   - **Web**: Add Firebase config to `web/index.html`

📖 **For detailed Firebase setup instructions, see [SETUP.md](SETUP.md)**

### 4. Run the App

```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Run on Chrome (web)
flutter run -d chrome

# Run on Android emulator
flutter run -d emulator-5554
```

## 📚 Detailed Setup Guide

For comprehensive setup instructions including:
- Platform-specific configurations
- Firebase detailed setup
- Troubleshooting guide
- Development best practices

👉 **See the complete [SETUP.md](SETUP.md) guide**

## 🏗️ Project Structure

```
lib/
├── exceptions/           # Custom exception classes
│   └── network_exception.dart
├── models/              # Data models
│   ├── habit.dart
│   ├── quote.dart
│   └── user.dart
├── screens/             # UI screens
│   ├── auth/           # Authentication screens
│   │   ├── login_screen.dart
│   │   └── signup_screen.dart
│   ├── habit_creation_screen.dart
│   ├── home_screen.dart
│   ├── premium_screen.dart
│   └── profile_screen.dart
├── services/            # Business logic & API services
│   ├── auth_service.dart
│   ├── habit_service.dart
│   └── quote_service.dart
├── widgets/             # Reusable UI components
│   ├── habit_card.dart
│   ├── premium_banner.dart
│   ├── quote_popup.dart
│   └── streak_counter.dart
└── main.dart           # App entry point
```

## 🔑 Key Files

- **`pubspec.yaml`**: Dependencies and app configuration
- **`lib/main.dart`**: Application entry point and routing
- **`SETUP.md`**: Comprehensive setup and configuration guide
- **`analysis_options.yaml`**: Dart analyzer configuration
- **`assets/quotes.json`**: Motivational quotes data

## 🧪 Development

### Run Tests

```bash
flutter test
```

### Code Formatting

```bash
flutter format .
```

### Code Analysis

```bash
flutter analyze
```

### Build for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS (macOS only)
flutter build ios --release

# Web
flutter build web

# Windows
flutter build windows

# Linux
flutter build linux

# macOS
flutter build macos
```

## 🔒 Security

- Never commit Firebase configuration files with real credentials
- Use Firebase security rules to protect user data
- Enable Firebase App Check for production
- Store sensitive data using `flutter_secure_storage`

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 Support

- **Documentation**: See [SETUP.md](SETUP.md) for detailed guides
- **Issues**: Report bugs or request features via [GitHub Issues](https://github.com/georgem66/Habit-Tracker/issues)
- **Flutter Docs**: https://docs.flutter.dev/
- **Firebase Docs**: https://firebase.google.com/docs

## 🎯 Roadmap

- [ ] Add habit categories and tags
- [ ] Implement data export/import
- [ ] Add charts and analytics
- [ ] Social features (share achievements)
- [ ] Dark mode support
- [ ] Multiple language support
- [ ] Offline mode improvements
- [ ] Widget support for home screen

## 👏 Acknowledgments

- Flutter team for the amazing framework
- Firebase for backend infrastructure
- All contributors and users

---

**Made with ❤️ using Flutter**

**Version**: 1.0.0  
**Last Updated**: February 2026
