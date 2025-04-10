import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/text_field_custom.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_cubit.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_state.dart';

class MobileLoginPage extends StatefulWidget {
  const MobileLoginPage({super.key});

  @override
  MobileLoginPageState createState() => MobileLoginPageState();
}

class MobileLoginPageState extends State<MobileLoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _login(BuildContext context) {
    if (!_validateFields(context)) return;
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    final user = UserModel(username: emailController.text, password: passwordController.text);
    loginCubit.login(user);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Hero(
          tag: "auth",
          child: Text(
            'Login',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state is LoginSuccessState) {
              GoRouter.of(context).pushReplacement(AppRouter.home);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login Successfully"),
              ));
            } else if (state is LoginFailureState) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("Error: ${state.message}"),
              ));
            }
          },
          builder: (context, state) {
            if (state is LoginLoadingState) {
              return const Center(child: SpinKitCubeGrid(color: Colors.black));
            }
            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Hero(
                    tag: "imageAuth",
                    child: Image.asset(
                      'assets/image/login.jpg',
                      height: 300,
                    ),
                  ),
                  const Text(
                    'Welcome Back!',
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  Textfeildcustom(obsecure: false, label: 'Enter your Username', controller: emailController),
                  const SizedBox(height: 10),
                  Textfeildcustom(obsecure: true, label: 'Enter your password', controller: passwordController),
                  const SizedBox(height: 20),
                  CustomButton(
                    color: Colors.black87,
                    text: "Log In",
                    colorText: Colors.white,
                    onPressed: () => _login(context),
                  ),
                  const SizedBox(height: 20),
                  const Text("Don't have an account?", textAlign: TextAlign.center),
                  const SizedBox(height: 10),
                  CustomButton(
                    color: Colors.black87,
                    text: 'Create Account',
                    colorText: Colors.white,
                    onPressed: () => GoRouter.of(context).push(AppRouter.signUp),
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


    if (passwordController.text.isEmpty || emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return false;
    }

    return true;
  }

}
