import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/repositories/profile_repo_imp.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/profile/presentation/widgets/profile_mobile_page.dart';
import 'package:smse/features/profile/presentation/widgets/profile_web_page.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ProfileCubit(ProfilRepoImp(ApiService(Dio()))),
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            BlocProvider.of<ProfileCubit>(context).fetchUser();

            if (constraints.maxWidth > 600) {
              // Web/Desktop Layout
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                body: const ProfileContentWeb(),
              );
            } else {
              // Mobile Layout
              return Scaffold(
                appBar: AppBar(
                  centerTitle: true,
                  title: const Text(
                    'Profile',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                body: const ProfileContentMobile(),
              );
            }
          },
        ),
      ),
    );
  }
}


