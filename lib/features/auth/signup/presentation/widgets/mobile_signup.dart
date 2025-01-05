import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/core/components/textFeildCustom.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';

import '../../../../../constants.dart';
class MobileSignup extends StatelessWidget {
   MobileSignup({super.key});
 TextEditingController name = TextEditingController();
 TextEditingController email = TextEditingController();
 TextEditingController password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final signUpCubit = BlocProvider.of<SignupCubit>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('SignUp',style: TextStyle(color: Colors.black ,fontSize: 30, fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocConsumer<SignupCubit,SignUpState>(
          listener: (context,state){
            if (state is SignupFailureState) {
              GoRouter.of(context).pushReplacement(AppRouter.KLogin);

              print(state.message);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Signup Successfully"),

              ));
            }

            if( state is SignupSuccessState ){
              print(state.signupModel);
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("faild"),

              ));
            }
          },
          builder: (context,state) {
            if (state is SignupLoadingState) {
              return const Center(child: CircularProgressIndicator());
            }


            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircleAvatar(
                    radius: 80,
                    backgroundColor: Colors.yellow,
                    backgroundImage: AssetImage(Constant.profileImage,),
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
                        .map((status) =>
                        DropdownMenuItem<String>(
                          value: status,
                          child: Text(status),
                        ))
                        .toList(),
                    onChanged: (value) {},
                  ),
                  const SizedBox(height: 24),
                  CustomButton(color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                    SignupModel user = SignupModel(
                      username: name.text,
                      email: email.text,
                      password: password.text,
                    );

                    signUpCubit.signup(user);
                    },)
                ],
              ),
            );
          })
      ),
    );
  }
}