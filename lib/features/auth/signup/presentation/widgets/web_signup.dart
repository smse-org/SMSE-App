import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/textFeildCustom.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';

class WebSignup extends StatelessWidget {
   WebSignup({super.key});
  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final signUpCubit = BlocProvider.of<SignupCubit>(context);

    return Scaffold(
      body: Center(
        child: Container(
          width: 400,
          padding: const EdgeInsets.all(16.0),
          child: BlocConsumer<SignupCubit,SignUpState>(
            listener: (context,state){
              if(state is SignupFailureState){
                GoRouter.of(context).pushReplacement(AppRouter.KLogin);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text("Signup success"),
                ));
              }

              if(state is SignupSuccessState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Faild to signup'),
                ));

              }

            },
            builder: (context,state) {
              if (state is SignupLoadingState) {
                return const Center(child: CircularProgressIndicator());
              }

              return Column(
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
                   Textfeildcustom(obsecure: false, label: "Enter Name",
                  controller: name,
                  ),


                  const SizedBox(height: 12),
                   Textfeildcustom(obsecure: false, label: "Enter Email",
                  controller: email,
                  ),


                  const SizedBox(height: 12),
                   Textfeildcustom(
                      obsecure: true, label: "Enter password",
                    controller: password,
                   ),
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
                  CustomButton(color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                    SignupModel user= SignupModel(
                      username: name.text,
                      email: email.text,
                      password: password.text,
                    );

                    signUpCubit.signup(user);


                    },)
                ],
              );
            }),
        ),
      ),
    );
  }
}