import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/auth/login/data/repositories/login_repo_imp.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_cubit.dart';

import '../widgets/mobile_widget.dart';
import '../widgets/web_widget.dart';

class ResponsiveLoginPage extends StatelessWidget {
  const ResponsiveLoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginCubit(LoginRepoImp(ApiService(Dio()))),
      child: Theme(
        data:  ThemeData.light().copyWith(
          scaffoldBackgroundColor: Colors.white,
        ),
        child: LayoutBuilder(

          builder: (context, constraints) {
            if (constraints.maxWidth > 600) {
              // Render web/desktop version
              return WebLoginPage();
            } else {
              // Render mobile version
              return const SafeArea(child: MobileLoginPage());
            }
          },
        ),
      ),
    );
  }
}


