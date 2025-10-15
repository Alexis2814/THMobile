import 'package:flutter/material.dart';
import 'screens/sign_up_screen.dart';
import 'screens/otp_screen.dart';
import 'screens/success_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Signup Form App",
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      initialRoute: '/',
      routes: {
        '/': (context) => const SignUpScreen(),
        '/otp': (context) => const OtpScreen(),
        '/success': (context) => const SuccessScreen(),
      },
    );
  }
}
