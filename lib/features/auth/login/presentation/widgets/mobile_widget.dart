import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/textFeildCustom.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_cubit.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_state.dart';

import '../../../../../constants.dart';
class MobileLoginPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login',style: TextStyle(color: Colors.black , fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context,state){
            if (state is LoginSuccessState) {
              GoRouter.of(context).pushReplacement(AppRouter.KHome);

              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login Successfully"),

              ));
            }

            if( state is LoginFailureState ){
              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                content: Text("Error : ${state.message}"),

              ));
            }
          },
          builder: (context,state) {
            if (state is LoginLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Text('Welcome Back!',
                      textAlign: TextAlign.start,
                      style: TextStyle(fontSize: 32,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(height: 20),
                  Textfeildcustom(obsecure: false, label: 'Enter your username',
                    controller: email,
                  ),

                  const SizedBox(height: 10),
                  Textfeildcustom(obsecure: true, label: 'Enter your password',
                    controller: password,
                  ),
                  const SizedBox(height: 20),
                  CustomButton(color: Colors.black87,
                    text: "Log In",
                    colorText: Colors.white,
                    onPressed: () {
                    UserModel user = UserModel(username: email.text, password: password.text);
                    loginCubit.login(user);
                    },),

                  const SizedBox(height: 20),
                  const Text(
                    'Forgot your password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 10),
                  CustomButton(color: Colors.black87,
                    text: 'Reset Password',
                    colorText: Colors.white,
                    onPressed: () {},),

                  const SizedBox(height: 20),
                  const Text(
                    "Don't have an account?",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 20,),
                  CustomButton(color: Colors.black87,
                    text: 'Create Account',
                    colorText: Colors.white,
                    onPressed: () {
                      GoRouter.of(context).push(AppRouter.KSignUp);
                    },),

                ],
              ),
            );
          }),
      ),
    );
  }
}
