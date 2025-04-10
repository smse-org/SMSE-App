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
    // TODO: implement dispose
    super.dispose();
    name.dispose();
    email.dispose();
    password.dispose();
  }
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
                GoRouter.of(context).pushReplacement(AppRouter.login);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(ServerFailuer(state.message).errMessage
                )));
              }

              if(state is SignupSuccessState){
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('Signup Successfully'),
                ));

              }

            },
            builder: (context,state) {
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

                  const SizedBox(height: 24),
                  CustomButton(color: Colors.black87,
                    text: "Create Account",
                    colorText: Colors.white,
                    onPressed: () {
                    if(!_validateFields(context)){
                      return;
                    }
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

   bool _validateFields(BuildContext context) {
     String e = email.text.trim();
     String username=name.text;
     if (password.text.isEmpty || email.text.isEmpty) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Please fill all fields")),
       );
       return false;
     }
     if(password.text.length<7){
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

     if (!ValidationHelper.isValidEmail(e)) {
       ScaffoldMessenger.of(context).showSnackBar(
         const SnackBar(content: Text("Invalid email format")),
       );
       return false;
     }
     return true;
   }
}