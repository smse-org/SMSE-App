import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/text_field_custom.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/validate_helper.dart';
import 'package:smse/core/utililes/validators.dart';
import 'package:smse/features/auth/signup/data/model/user_model.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';
import 'package:smse/constants.dart';

class MobileSignup extends StatefulWidget {
  const MobileSignup({super.key});

  @override
  MobileSignupState createState() => MobileSignupState();
}

class MobileSignupState extends State<MobileSignup> {
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
              GoRouter.of(context).pushReplacement(AppRouter.login);
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
                  Textfeildcustom(
                    controller: nameController,
                    label: "Enter Username",
                    obsecure: false,
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild to show validation
                    },
                  ),
                  if (nameController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Validators.getUsernameError(nameController.text) ?? '',
                        style: TextStyle(
                          color: Validators.getUsernameError(nameController.text) == null ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Textfeildcustom(
                    controller: emailController,
                    label: "Enter Email",
                    obsecure: false, onChanged: (String ) {  },
                  ),
                  const SizedBox(height: 12),
                  Textfeildcustom(
                    controller: passwordController,
                    label: "Enter Password",
                    obsecure: true,
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild to show validation
                    },
                  ),
                  if (passwordController.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Validators.getPasswordError(passwordController.text) ?? '',
                        style: TextStyle(
                          color: Validators.getPasswordError(passwordController.text) == null ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  CustomButton(
                    color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                      if (_validateFields(context)) {
                        SignupModel user = SignupModel(
                          username: nameController.text,
                          email: emailController.text,
                          password: passwordController.text,
                        );
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
    String username = nameController.text;

    if (passwordController.text.isEmpty || emailController.text.isEmpty || username.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return false;
    }

    String? usernameError = Validators.getUsernameError(username);
    if (usernameError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(usernameError)),
      );
      return false;
    }

    String? passwordError = Validators.getPasswordError(passwordController.text);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError)),
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
