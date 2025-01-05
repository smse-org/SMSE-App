import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/textFeildCustom.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_cubit.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_state.dart';

import '../../../../../constants.dart';
class WebLoginPage extends StatelessWidget {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final loginCubit = BlocProvider.of<LoginCubit>(context);
    return Scaffold(
      body: Center(
        child: Container(
          width: 800,
          padding: const EdgeInsets.all(16.0),
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: BlocConsumer<LoginCubit,LoginState>(
              listener: (context,state){
                if (state is LoginFailureState) {
                  print(state.message);
                  ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                    content: Text(state.message),

                  ));
                }

                if( state is LoginSuccessState ){
                  print(state.token);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text("Login Successfully"),
                    backgroundColor: Colors.green,

                  ));
                  GoRouter.of(context).pushReplacement(AppRouter.KHome);
                }
              },
              builder: (context,state) {
                if (state is LoginLoadingState) {
                  return const Center(child: CircularProgressIndicator());
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Login', style: TextStyle(
                        fontSize: 32, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center),
                    const SizedBox(height: 30),
                    const Text('Email', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start),
                    const SizedBox(height: 10),

                    Textfeildcustom(obsecure: false, label: 'Enter your Email',
                      controller: email,
                    ),

                    const SizedBox(height: 10),
                    const Text('Password', style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.start),
                    const SizedBox(height: 10),
                    Textfeildcustom(
                      obsecure: true, label: 'Enter your password',
                      controller: password,
                    ),

                    const SizedBox(height: 20),
                    ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(Constant.whiteColor),
                        padding: const EdgeInsets.all(20),

                      ),
                      onPressed: () {
                        UserModel user= UserModel(username: email.text, password: password.text);
                        loginCubit.login(user);
                      },
                      child: const Text('Login', style: TextStyle(color: Colors
                          .white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(height: 30,),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            GoRouter.of(context).push(AppRouter.KSignUp);

                          },
                          child: const Text('Sign Up', style: TextStyle(
                              color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                        TextButton(
                          onPressed: () {},
                          child: const Text('Forgot Password?',
                              style: TextStyle(color: Colors.blue,
                                  fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                );
              }),
          ),
        ),
      ),
    );
  }
}