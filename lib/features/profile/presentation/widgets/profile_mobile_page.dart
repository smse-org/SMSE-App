import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:random_avatar/random_avatar.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/core/services/notification_settings_service.dart';
import 'package:smse/features/profile/data/services/avatar_service.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_state.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';
import 'package:smse/features/profile/presentation/controller/notification_settings_cubit.dart';

class ProfileContentMobile extends StatefulWidget {
  const ProfileContentMobile({super.key});

  @override
  State<ProfileContentMobile> createState() => _ProfileContentMobileState();
}

class _ProfileContentMobileState extends State<ProfileContentMobile> {
  final AvatarService _avatarService = AvatarService();
  String? _avatarPath;
  bool _isSvg = false;
  final List<String> _randomAvatars = List.generate(8, (index) => 'avatar_$index');

  @override
  void initState() {
    super.initState();
    _loadAvatar();
  }

  Future<void> _loadAvatar() async {
    try {
      final path = await _avatarService.getAvatarPath();
      if (path != null) {
        setState(() {
          _avatarPath = path;
          _isSvg = path.toLowerCase().endsWith('.svg');
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to load avatar: ${e.toString()}');
    }
  }

  Future<void> _pickImage() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      
      if (image != null) {
        final savedPath = await _avatarService.saveAvatarToLocal(File(image.path));
        setState(() {
          _avatarPath = savedPath;
          _isSvg = false;
        });
      }
    } catch (e) {
      _showErrorSnackBar('Failed to pick image: ${e.toString()}');
    }
  }

  void _showErrorSnackBar(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Dismiss',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );
  }

  void _showAvatarOptions() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Choose Avatar'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Select from gallery or choose a random avatar'),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                // Gallery option
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    _pickImage();
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Icon(Icons.photo_library, size: 40),
                  ),
                ),
                // Random avatars
                ..._randomAvatars.map((avatarId) => GestureDetector(
                  onTap: () async {
                    try {
                      Navigator.pop(context);
                      final svgString = RandomAvatarString(avatarId);
                      // Save the SVG string to a file
                      final localPath = await _avatarService.getLocalPath();
                      final fileName = 'avatar_${DateTime.now().millisecondsSinceEpoch}.svg';
                      final file = File('$localPath/$fileName');
                      await file.writeAsString(svgString);
                      await _avatarService.saveAvatarPath(file.path);
                      setState(() {
                        _avatarPath = file.path;
                        _isSvg = true;
                      });
                    } catch (e) {
                      _showErrorSnackBar('Failed to save random avatar: ${e.toString()}');
                    }
                  },
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(40),
                      border: Border.all(color: Colors.grey[300]!),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(40),
                      child: RandomAvatar(avatarId, height: 80, width: 80),
                    ),
                  ),
                )),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => NotificationSettingsCubit(NotificationSettingsService())
            ..loadSettings(),
        ),
      ],
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Account Information
              Row(
                children: [
                  GestureDetector(
                    onTap: _showAvatarOptions,
                    child: Stack(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          child: _avatarPath != null
                              ? _isSvg
                                  ? ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: SvgPicture.file(
                                        File(_avatarPath!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        placeholderBuilder: (context) => const CircularProgressIndicator(),
                                      ),
                                    )
                                  : ClipRRect(
                                      borderRadius: BorderRadius.circular(40),
                                      child: Image.file(
                                        File(_avatarPath!),
                                        width: 80,
                                        height: 80,
                                        fit: BoxFit.cover,
                                        errorBuilder: (context, error, stackTrace) {
                                          return const Icon(Icons.error_outline, size: 40);
                                        },
                                      ),
                                    )
                              : Image.asset(
                                  Constant.profileImage,
                                  width: 80,
                                  height: 80,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.error_outline, size: 40);
                                  },
                                ),
                        ),
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: Container(
                            padding: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: const Icon(
                              Icons.camera_alt,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                        ),
                      ],
                    ),
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
              BlocBuilder<NotificationSettingsCubit, NotificationSettingsState>(
                builder: (context, state) {
                  final notificationsEnabled = state is NotificationSettingsLoaded
                      ? state.notificationsEnabled
                      : true;

                  return Card(
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
              ListTile(
                title: const Text("All files Uploaded"),
                leading: Icon(Icons.upload_file_sharp, color: Colors.grey[700]),
                onTap: () {
                  GoRouter.of(context).push(AppRouter.contentPage);
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
              // const Text(
              //   "Feedback & Support",
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              const SizedBox(height: 16),
              // ElevatedButton(
              //   onPressed: () {},
              //   style: ElevatedButton.styleFrom(
              //     backgroundColor: Colors.grey[300],
              //     foregroundColor: Colors.black,
              //   ),
              //   child: const Center(
              //     child: Text("Send Feedback"),
              //   ),
              // ),
              BlocListener<LogoutCubit,LogoutState>(
                listener: ( context, state) {
                  if(state is LogoutFailure){
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${state.message}')),
                    );
                  }else if(state is LogoutSuccess){
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
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)
                  ),
                  onPressed: () {
                    BlocProvider.of<LogoutCubit>(context).logout();
                  },
                ),
              )
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
