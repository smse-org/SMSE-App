import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/services/notification_settings_service.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository_impl.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_state.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';
import 'package:smse/features/profile/presentation/controller/notification_settings_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/preferences_cubit.dart';
import 'package:smse/features/profile/presentation/widgets/model_preferences_section.dart';
import 'package:smse/features/uploded_content/presentation/screen/content_page.dart';
import 'package:smse/features/uploded_content/data/repositories/display_content_repo_imp.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:dio/dio.dart';

class ProfileContentWeb extends StatelessWidget {
  const ProfileContentWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationSettingsCubit(NotificationSettingsService())
            ..loadSettings(),
        ),
        BlocProvider(
          create: (context) => PreferencesCubit(
            PreferencesRepositoryImpl(ApiService(Dio())),
          ),
        ),
        BlocProvider(
          create: (context) => ContentCubit(
            DisplayContentRepoImp(ApiService(Dio())),
          ),
        ),
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Information
              Row(
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey[300],
                    child: Image.asset(
                      Constant.profileImage,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const Icon(Icons.error_outline, size: 40);
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  BlocBuilder<ProfileCubit, ProfileState>(
                    builder: (context, state) {
                      if (state is ProfileSuccessState) {
                        return UserDataCard(
                          username: state.userData.username,
                          email: state.userData.email,
                        );
                      }
                      return const UserDataCard(
                        username: "Loading...",
                        email: "Loading...",
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Notifications Card
              BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
                builder: (context, state) {
                  final notificationsEnabled = state is NotificationSettingsLoaded
                      ? state.notificationsEnabled
                      : true;

                  return Card(
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.notifications),
                      title: const Text('Notifications'),
                      subtitle: Text(
                        notificationsEnabled
                            ? 'Notifications are enabled'
                            : 'Notifications are disabled',
                      ),
                      trailing: Switch(
                        value: notificationsEnabled,
                        onChanged: (value) {
                          context.read<NotificationSettingsCubit>().toggleNotifications(value);
                        },
                      ),
                    ),
                  );
                },
              ),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text("All files Uploaded"),
                  leading: Icon(Icons.upload_file_sharp, color: Colors.grey[700]),
                  onTap: () {
                    // Navigate to content page with proper context
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const ContentPage(),
                      ),
                    );
                  },
                ),
              ),

              const SizedBox(height: 32),

              // Model Preferences Section
              const ModelPreferencesSection(),

              const SizedBox(height: 32),

              // Saved Searches
              const Text(
                "Saved Searches",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text("Sunset Beach Photo"),
                  leading: Icon(Icons.photo, color: Colors.grey[700]),
                  onTap: () {},
                ),
              ),
              Card(
                elevation: 2,
                child: ListTile(
                  title: const Text("Document on AI"),
                  leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
                  onTap: () {},
                ),
              ),
              const SizedBox(height: 32),

              // Logout Button
              Center(
                child: BlocListener<LogoutCubit, LogoutState>(
                  listener: (context, state) {
                    if (state is LogoutFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    } else if (state is LogoutSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Logout Successfully')),
                      );
                      GoRouter.of(context).go(AppRouter.login);
                    }
                  },
                  child: PushableButton(
                    hslColor: HSLColor.fromColor(Colors.blueAccent),
                    height: 50,
                    child: const Text(
                      'Logout',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      BlocProvider.of<LogoutCubit>(context).logout();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class UserDataCard extends StatelessWidget {
  const UserDataCard({super.key, required this.username, required this.email});
  final String username;
  final String email;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          username.toUpperCase(),
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}
