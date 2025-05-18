import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/text_field_custom.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/utililes/validate_helper.dart';
import 'package:smse/core/utililes/validators.dart';
import 'package:smse/features/auth/signup/data/model/user_model.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';

class WebSignup extends StatefulWidget {
  const WebSignup({super.key});

  @override
  State<WebSignup> createState() => _WebSignupState();
}

class _WebSignupState extends State<WebSignup> {
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  @override
  void dispose() {
    name.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final signUpCubit = BlocProvider.of<SignupCubit>(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<SignupCubit, SignUpState>(
            listener: (context, state) {
              if (state is SignupFailureState) {
                GoRouter.of(context).pushReplacement(AppRouter.login);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(ServerFailuer(state.message).errMessage)),
                );
              }

              if (state is SignupSuccessState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Signup Successfully')),
                );
              }
            },
            builder: (context, state) {
              if (state is SignupLoadingState) {
                return const Center(child: SpinKitCubeGrid(color: Colors.black87));
              }

              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Hero(
                    tag: 'auth',
                    child: Text(
                      'Sign Up',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Hero(
                    tag: "imageAuth",
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.grey[300],
                      backgroundImage: const AssetImage(Constant.profileImage),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Textfeildcustom(
                    obsecure: false,
                    label: "Enter Username",
                    controller: name,
                    onChanged: (value) {
                      setState(() {
                      }); // Trigger rebuild to show validation
                    },
                  ),
                  if (name.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Validators.getUsernameError(name.text) ?? '',
                        style: TextStyle(
                          color: Validators.getUsernameError(name.text) == null ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 12),
                  Textfeildcustom(
                    obsecure: false,
                    label: "Enter Email",
                    controller: email, onChanged: (String ) {  },
                  ),
                  const SizedBox(height: 12),
                  Textfeildcustom(
                    obsecure: true,
                    label: "Enter password",
                    controller: password,
                    onChanged: (value) {
                      setState(() {}); // Trigger rebuild to show validation
                    },
                  ),
                  if (password.text.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        Validators.getPasswordError(password.text) ?? '',
                        style: TextStyle(
                          color: Validators.getPasswordError(password.text) == null ? Colors.green : Colors.red,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  const SizedBox(height: 24),
                  CustomButton(
                    color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                      if (!_validateFields(context)) {
                        return;
                      }
                      SignupModel user = SignupModel(
                        username: name.text,
                        email: email.text,
                        password: password.text,
                      );
                      signUpCubit.signup(user);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  bool _validateFields(BuildContext context) {
    String e = email.text.trim();
    String username = name.text;

    if (password.text.isEmpty || email.text.isEmpty || username.isEmpty) {
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

    String? passwordError = Validators.getPasswordError(password.text);
    if (passwordError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(passwordError)),
      );
      return false;
    }

    if (!ValidationHelper.isValidEmail(e)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Invalid email format")),
      );
      return false;
    }
    return true;
  }
}