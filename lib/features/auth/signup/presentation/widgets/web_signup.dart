import 'package:flutter/material.dart';
import 'package:smse/components/custom_button.dart';
import 'package:smse/constants.dart';

import '../../../../../components/textFeildCustom.dart';
class WebSignup extends StatelessWidget {
  const WebSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Sign Up',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.grey[300],
                backgroundImage: const AssetImage(Constant.profileImage),
              ),
              const SizedBox(height: 24),
              const Textfeildcustom(obsecure: false, label: "Enter Name"),


              const SizedBox(height: 12),
              const Textfeildcustom(obsecure: false, label: "Enter Email"),


              const SizedBox(height: 12),
              const Textfeildcustom(obsecure: true, label: "Enter password"),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Status:'),
                  const SizedBox(width: 20),
                  const Text('Student'),
                  Radio(value: 0, groupValue: 1, onChanged: (value) {}),
                  const SizedBox(width: 20),
                  const Text('Employed'),
                  Radio(value: 1, groupValue: 1, onChanged: (value) {}),
                ],
              ),
              const SizedBox(height: 24),
             const CustomButton(color: Constant.blackColor, text: "Create Account", colorText: Colors.white)
            ],
          ),
        ),
      ),
    );
  }
}