import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/textFeildCustom.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/validate_helper.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';

import '../../../../../constants.dart';

class MobileSignup extends StatefulWidget {
  const MobileSignup({super.key});

  @override
  _MobileSignupState createState() => _MobileSignupState();
}

class _MobileSignupState extends State<MobileSignup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Hero(
          tag: "auth",
          child: Text(
            'Sign Up',
            style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SignupCubit, SignUpState>(
          listener: (context, state) {
            if (state is SignupFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(ServerFailuer(state.message).errMessage)),
              );
            } else if (state is SignupSuccessState) {
              GoRouter.of(context).pushReplacement(AppRouter.KLogin);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Signup Successfully")),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  const Hero(
                    tag: "imageAuth",
                    child: CircleAvatar(
                      radius: 80,
                      backgroundColor: Colors.yellow,
                      backgroundImage: AssetImage(Constant.profileImage),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Textfeildcustom(controller: nameController, label: "Enter Name", obsecure: false),
                  const SizedBox(height: 12),
                  Textfeildcustom(controller: emailController, label: "Enter Email", obsecure: false),
                  const SizedBox(height: 12),
                  Textfeildcustom(controller: passwordController, label: "Enter Password", obsecure: true),
                  const SizedBox(height: 12),
                  CustomButton(
                    color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                      SignupModel user = SignupModel(
                        username: nameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      );
                      if (_validateFields(context)){
                        BlocProvider.of<SignupCubit>(context).signup(user);

                      }
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
  bool _validateFields(BuildContext context) {
    String email = emailController.text.trim();
    String password = passwordController.text.trim();
    String username=nameController.text;
    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return false;
    }
    if(passwordController.text.length<7){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Password must be at least 7 characters")),
      );
      return false;
    }
    if (!RegExp(r'^[a-zA-Z0-9]+$').hasMatch(username)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Username must contain only letters and numbers, no spaces or symbols allowed")),
      );
      return false;
    }

    if (!ValidationHelper.isValidEmail(email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email format")),
      );
      return false;
    }
    return true;
  }
}
