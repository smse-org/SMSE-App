import 'package:flutter/material.dart';

import '../../../../../components/textFeildCustom.dart';
import '../../../../../constants.dart';
class WebLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text('Login', style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
                const SizedBox(height: 30),
                const Text('Email', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                const SizedBox(height: 10),

                const Textfeildcustom(obsecure: false, label: 'Enter your Email'),

                const SizedBox(height: 10),
                const Text('Password', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), textAlign: TextAlign.start),
                const SizedBox(height: 10),
                const Textfeildcustom(obsecure: true, label: 'Enter your password'),

                const SizedBox(height: 20),
                ElevatedButton(

                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(Constant.whiteColor),
                    padding: EdgeInsets.all(20),

                  ),
                  onPressed: () {},
                  child: const Text('Login',style: TextStyle(color: Colors.white , fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 30,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () {},
                      child: const Text('Sign Up',style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold)),
                    ),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot Password?',style: TextStyle(color: Colors.blue , fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}