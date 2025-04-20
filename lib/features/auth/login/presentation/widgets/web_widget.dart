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

import '../../../../../constants.dart';
class WebLoginPage extends StatelessWidget {
  WebLoginPage({super.key});

  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

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
                    ScaffoldMessenger.of(context).showSnackBar( SnackBar(
                      content: Text(state.message),

                    ));
                  }

                  if( state is LoginSuccessState ){
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                      content: Text("Login Successfully"),
                      backgroundColor: Colors.green,

                    ));
                    GoRouter.of(context).pushReplacement(AppRouter.home);
                  }
                },
                builder: (context,state) {
                  if (state is LoginLoadingState) {
                    return const Center(child: SpinKitCubeGrid(color: Colors.black,));
                  }
                  return SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Hero(
                          tag: "auth",
                          child: Text('Login', style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center),
                        ),
                        const SizedBox(height: 10),
                        Hero(
                          tag: 'imageAuth',
                            child: Image.asset('assets/image/login.jpg', height: 250)),
                        const SizedBox(height: 20),
                        const Text('Username', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.start),
                        const SizedBox(height: 10),
                    
                        Textfeildcustom(obsecure: false, label: 'Enter your Username',
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
                            backgroundColor: const Color(Constant.blackColor),
                            padding: const EdgeInsets.all(20),
                    
                          ),
                          onPressed: () {
                            if(!_validateFields(context)) return;
                            UserModel user= UserModel(username: email.text, password: password.text);
                            loginCubit.login(user);
                          },
                          child: const Text('Login', style: TextStyle(color: Colors
                              .white, fontWeight: FontWeight.bold)),
                        ),
                        const SizedBox(height: 30,),
                        const Text('Don\'t have an account?', style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center),
                        const SizedBox(height: 10),
                        CustomButton(
                          onPressed: () {
                            GoRouter.of(context).push(AppRouter.signUp);

                          },
                          text: 'Sign Up',
                          color: Colors.black,
                          colorText: Colors.white,
                        ),
                      ],
                    ),
                  );
                }),
          ),
        ),
      ),
    );
  }
  bool _validateFields(BuildContext context) {


    if (password.text.isEmpty || email.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return false;
    }
    return true;
  }
}