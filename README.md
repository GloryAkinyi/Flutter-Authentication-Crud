# **Firebase Authentication & Realtime Database Integration in Flutter**

## **1. Project Overview**

This project integrates **Firebase Authentication** and **Firebase Realtime Database** into a Flutter application.

Firebase Authentication manages user registration and login, while Firebase Realtime Database stores and manages product information.

### **Key Features**

- **User Registration:** Create an account using an email address and password.
- **User Login:** Authenticate registered users securely.
- **Product Upload:** Save product details to Firebase Realtime Database.
- **View Products:** Retrieve and display products from the database.
- **Update Products:** Edit existing product information.
- **Delete Products:** Remove products from the database.
- **Real-Time Updates:** Automatically reflect database changes in the product list.

## **2. Requirements**

Before starting, ensure you have installed:

- **Flutter SDK**
- **Dart SDK**
- **Android Studio** or **Visual Studio Code**
- **A Google account**
- **A Firebase project**
- **An internet connection**

Check that Flutter is installed by running:

```bash
flutter doctor
```

## **3. Create a Firebase Project**

1. Visit the [Firebase Console](https://console.firebase.google.com/).
2. Click **Create a project** or select an existing project.
3. Follow the instructions to complete the setup.
4. Add your Flutter application's Android app to the Firebase project.
5. Enter the correct Android package name for your application.

**Important:** The Android package name registered in Firebase must match the application's package name in your Flutter project.

## **4. Configure Firebase in Flutter**

Open your project terminal and install the required packages:

```bash
flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add firebase_database
```

### **Configure Firebase Using FlutterFire CLI**

Run the following commands:

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

Select your Firebase project and the platforms you want to support.

**Expected Result:** A file named `firebase_options.dart` should be generated inside the `lib/` directory.

### **Initialize Firebase**

Open `lib/main.dart` and initialize Firebase before running the application.

```dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}
```

Keep your existing `MyApp` widget and application navigation.

### **Why Is Firebase Initialization Important?**

Firebase must be initialized before using Authentication or Realtime Database services. Otherwise, the application may report Firebase initialization errors.

