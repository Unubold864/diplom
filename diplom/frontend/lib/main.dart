import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:frontend/view/login_screen.dart';
import 'package:frontend/view/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyBZNAWmMJl_fP4Ai9D8yO8zuM8Mwno1ZT0",
            authDomain: "flutter-complete-app-50151.firebaseapp.com",
            projectId: "flutter-complete-app-50151",
            storageBucket: "flutter-complete-app-50151.firebasestorage.app",
            messagingSenderId: "636632521400",
            appId: "1:636632521400:web:a502a24b7a359efed5f24d",
            measurementId: "G-XBSQ8RW63R"));
  } else {
    await Firebase.initializeApp();
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return AppMainScreen();
          } else {
            return LoginScreen();
          }
        },
      ),
    );
  }
}
