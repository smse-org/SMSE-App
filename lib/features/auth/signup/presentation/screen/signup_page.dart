import 'package:flutter/material.dart';
import 'package:smse/features/auth/signup/presentation/widgets/mobile_signup.dart';
import 'package:smse/features/auth/signup/presentation/widgets/web_signup.dart';
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 600) {
          // Render web/desktop version
          return WebSignup();
        } else {
          // Render mobile version
          return MobileSignup();
        }
      },
    );
  }
}
