import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:pushable_button/pushable_button.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_state.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_cubit.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';
import 'package:smse/features/uploded_content/presentation/screen/content_page.dart';

class ProfileContentWeb extends StatelessWidget {
  const ProfileContentWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: double.infinity),
        child: SingleChildScrollView(
            padding:
                const EdgeInsets.symmetric(horizontal: 32.0, vertical: 24.0),
            child: BlocConsumer<ProfileCubit, ProfileState>(
                listener: (context, state) {
              if (state is ProfileErrorState) {
                // Handle error state if needed, e.g., show a SnackBar
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: ${state.message}')),
                );
              }
            }, builder: (context, state) {
              if (state is ProfileLoadingState) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is ProfileSuccessState) {
                final user= state.userData;
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Account Information
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: Colors.grey[300],
                          backgroundImage:
                              const AssetImage(Constant.profileImage),
                        ),
                        const SizedBox(width: 16),
                         Center(
                          child: Text(
                            "${user.username}",
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            "${user.email}",
                            style: TextStyle(color: Colors.grey[600]),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // User Preferences
                    const Text(
                      "User Preferences",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
                    const SizedBox(height: 24),
                    ListTile(
                      title: const Text("All files Uploaded"),
                      leading: Icon(Icons.upload_file_sharp, color: Colors.grey[700]),
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const ContentPage()));
                      },
                    ),
                    // Saved Searches
                    const Text(
                      "Saved Searches",
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    ListTile(
                      title: const Text("Sunset Beach Photo"),
                      leading: Icon(Icons.photo, color: Colors.grey[700]),
                      onTap: () {},
                    ),
                    ListTile(
                      title: const Text("Document on AI"),
                      leading: Icon(Icons.insert_drive_file,
                          color: Colors.grey[700]),
                      onTap: () {},
                    ),
                    const SizedBox(height: 24),

                    // Feedback & Support
                    // const Center(
                    //   child: Text(
                    //     "Feedback & Support",
                    //     style: TextStyle(
                    //         fontSize: 18, fontWeight: FontWeight.bold),
                    //   ),
                    // ),
                    const SizedBox(height: 16),
                    Center(
                      child: SizedBox(
                        width: MediaQuery.sizeOf(context).width * 0.5,
                        // child: ElevatedButton(
                        //   onPressed: () {},
                        //   style: ElevatedButton.styleFrom(
                        //     backgroundColor: Colors.grey[300],
                        //     foregroundColor: Colors.black,
                        //     minimumSize: const Size(200, 50),
                        //   ),
                        //   child: const Center(
                        //     child: Text("Send Feedback"),
                        //   ),
                        // ),
                        child: BlocListener<LogoutCubit,LogoutState>(

                          listener: ( context,  state) {
                            if(state is LogoutFailure){
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Error: ${state.message}')),
                              );
                            }else if(state is LogoutSuccess){
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Logout Successfully')),
                              );
                              GoRouter.of(context).go(AppRouter.KLogin);
                            }
                          },
                          child: PushableButton(hslColor: HSLColor.fromColor(Colors.blueAccent), height: 50,
                            child: const Text('Logout', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                            onPressed: (){
                              BlocProvider.of<LogoutCubit>(context).logout();

                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const Center(child: Text("Error"));
              }
            })),
      ),
    );
  }
}
