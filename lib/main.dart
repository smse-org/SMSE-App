import 'package:flutter/material.dart';
import 'package:smse/features/auth/login/presentation/screen/login.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';

import 'features/auth/signup/presentation/screen/signup_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomePage(),
    );
  }
}