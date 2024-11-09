import 'package:flutter/material.dart';
import 'package:smse/components/custom_button.dart';

import '../../../../../components/textFeildCustom.dart';
import '../../../../../constants.dart';
class MobileLoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold)),
      ),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Welcome Back!',
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 32,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 20),
              Textfeildcustom(obsecure: false, label: 'Enter your Email'),

              SizedBox(height: 10),
              Textfeildcustom(obsecure: true, label: 'Enter your password'),
              SizedBox(height: 20),
              CustomButton(color:Constant.whiteColor , text: "Log In", colorText: Colors.white),

              SizedBox(height: 20),
              Text(
                'Forgot your password?',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 10),
              CustomButton(color:Constant.blackColor , text: 'Reset Password',colorText: Colors.black,),

              SizedBox(height: 20),
              Text(
                "Don't have an account?",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20,),
              CustomButton(color:Constant.blackColor , text: 'Create Account',colorText: Colors.black,),

            ],
          ),
        ),
      ),
    );
  }
}
