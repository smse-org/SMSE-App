import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';

class ProfileContentMobile extends StatelessWidget {
  const ProfileContentMobile({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Account Information
            Row(
              children: [
                CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.grey[300],
                  backgroundImage: const AssetImage(Constant.profileImage),
                ),
                const SizedBox(width: 16),
                BlocConsumer<ProfileCubit, ProfileState>(
                  listener: (context, state) {
                    if (state is ProfileErrorState) {
                      // Handle error state if needed, e.g., show a SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: ${state.message}')),
                      );
                    }
                  },
                  builder: (context, state) {
                    if (state is ProfileLoadingState) {
                      // Use Skeletonizer to display a skeleton loader
                      return const Skeletonizer(
                        enabled: true,
                        child: UserDataCard(username: "", email: ""),
                      );
                    } else if (state is ProfileSuccessState) {
                      final user = state.userData;
                      return UserDataCard(username: user.username, email: user.email);
                    } else {
                      return const Center(child: CircularProgressIndicator());
                    }
                  },
                ),
              ],
            ),
            const SizedBox(height: 24),

            // User Preferences
            const Text(
              "User Preferences",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              title: const Text("Set default search file types"),
              value: true,
              onChanged: (value) {},
            ),
            SwitchListTile(
              title: const Text("Enable notifications"),
              value: false,
              onChanged: (value) {},
            ),
            ListTile(
              title: const Text("All files Uploaded"),
              leading: Icon(Icons.upload_file_sharp, color: Colors.grey[700]),
              onTap: () {
                GoRouter.of(context).push(AppRouter.kContetnPage);
              },
            ),

            const SizedBox(height: 24),

            // Saved Searches
            const Text(
              "Saved Searches",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: const Text("Sunset Beach Photo"),
              leading: Icon(Icons.photo, color: Colors.grey[700]),
              onTap: () {},
            ),
            ListTile(
              title: const Text("Document on AI"),
              leading: Icon(Icons.insert_drive_file, color: Colors.grey[700]),
              onTap: () {},
            ),
            const SizedBox(height: 24),

            // Feedback & Support
            const Text(
              "Feedback & Support",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                foregroundColor: Colors.black,
              ),
              child: const Center(
                child: Text("Send Feedback"),
              ),
            ),
          ],
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
          username,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          email,
          style: TextStyle(color: Colors.grey[600]),
        ),
      ],
    );
  }
}
