import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/repositories/logout/logout_repo_imp.dart';
import 'package:smse/features/profile/data/repositories/profile_repo_imp.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';
import 'package:smse/features/profile/presentation/widgets/profile_mobile_page.dart';
import 'package:smse/features/profile/presentation/widgets/profile_web_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => ProfileCubit(ProfilRepoImp(ApiService(Dio()))),
        ),
        BlocProvider(
          create: (context) => LogoutCubit(LogoutRepoImp(ApiService(Dio()))),
        ),
      ],
      child: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {},
        child: LayoutBuilder(
          builder: (context, constraints) {
            BlocProvider.of<ProfileCubit>(context).fetchUser();

            // For web, always use web layout
            if (kIsWeb) {
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
            }
            
            // For mobile, use responsive layout
            if (constraints.maxWidth > 600) {
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


