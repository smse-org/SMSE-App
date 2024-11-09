import 'package:flutter/material.dart';
import 'package:smse/components/custom_button.dart';

import '../../../../../components/textFeildCustom.dart';
import '../../../../../constants.dart';
class MobileSignup extends StatelessWidget {
  const MobileSignup({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SignUp',style: TextStyle(color: Colors.black ,fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const CircleAvatar(
                radius: 80,
                backgroundColor: Colors.yellow,
                backgroundImage:AssetImage(Constant.profileImage,),
              ),
              const SizedBox(height: 24),
              const Textfeildcustom(obsecure: false, label: "Enter Name"),
          
            
              const SizedBox(height: 12),
              const Textfeildcustom(obsecure: false, label: "Enter Email"),
          
             
              const SizedBox(height: 12),
              const Textfeildcustom(obsecure: true, label: "Enter password"),
              
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Select',
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                items: ['Student', 'Employed']
                    .map((status) => DropdownMenuItem<String>(
                  value: status,
                  child: Text(status),
                ))
                    .toList(),
                onChanged: (value) {},
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