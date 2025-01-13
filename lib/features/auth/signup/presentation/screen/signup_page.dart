import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo_imp.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_cubit.dart';
import 'package:smse/features/auth/signup/presentation/widgets/mobile_signup.dart';
import 'package:smse/features/auth/signup/presentation/widgets/web_signup.dart';
class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return  BlocProvider(
      create: (context) => SignupCubit(SignUpRepoImp(ApiService(Dio()))),
      child: Theme(
        data: ThemeData.light(),
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Render web/desktop version
              return  WebSignup();
            } else {
              // Render mobile version
              return SafeArea(child: MobileSignup());
            }
          },
        ),
      ),
    );
  }
}
