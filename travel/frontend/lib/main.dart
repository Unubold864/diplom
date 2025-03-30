import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:frontend/pages/login.dart';
import 'package:frontend/pages/home_page.dart';
import 'package:frontend/pages/profile_page.dart';
import 'package:frontend/pages/sign_up.dart';
import 'package:frontend/pages/forget_password.dart';
import 'package:frontend/services/api_service.dart'; // Import the API service

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Travel App',
      debugShowCheckedModeBanner: false,
      // Use the global navigator key from ApiService
      navigatorKey: ApiService.navigatorKey,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        textTheme: GoogleFonts.mulishTextTheme(Theme.of(context).textTheme),
      ),
      home: const Login(),
      routes: {
        '/login': (context) => const Login(),
        '/home': (context) => const HomePage(),
        '/profile': (context) => const ProfilePage(),
        '/signup': (context) => const SignUp(),
        '/forget_password': (context) => const ForgetPassword(),
      },
    );
  }
}
