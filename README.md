Firebase Authentication & Realtime Database Integration in Flutter

1. Project Overview

This project integrates Firebase Authentication and Firebase Realtime Database into a Flutter application.

Firebase Authentication manages user registration and login, while Firebase Realtime Database stores and manages product information.

Key Features

User Registration: Create an account using an email address and password.

User Login: Authenticate registered users securely.

Product Upload: Save product details to Firebase Realtime Database.

View Products: Retrieve and display products from the database.

Update Products: Edit existing product information.

Delete Products: Remove products from the database.

Real-Time Updates: Automatically reflect database changes in the product list.

2. Requirements

Before starting, ensure you have installed:

Flutter SDK

Dart SDK

Android Studio or Visual Studio Code

A Google account

A Firebase project

An internet connection

Check that Flutter is installed by running:

flutter doctor

3. Create a Firebase Project

Visit the Firebase Console.

Click Create a project or select an existing project.

Follow the instructions to complete the setup.

Add your Flutter application's Android app to the Firebase project.

Enter the correct Android package name for your application.

Important: The Android package name registered in Firebase must match the application's package name in your Flutter project.

4. Configure Firebase in Flutter

Open your project terminal and install the required packages:

flutter pub add firebase_core
flutter pub add firebase_auth
flutter pub add firebase_database

Configure Firebase using FlutterFire CLI:

dart pub global activate flutterfire_cli
flutterfire configure

Select your Firebase project and the platforms you want to support.

Expected result: A file named firebase_options.dart should be generated inside the lib/ directory.

Initialize Firebase

Open lib/main.dart and initialize Firebase before running the application.

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

Keep your existing MyApp widget and application navigation.

Why is initialization important?

Firebase must be initialized before using Authentication or Realtime Database services. Otherwise, the application may report Firebase initialization errors.

