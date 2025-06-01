import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/web.dart';

class MobileLayout extends StatefulWidget {
  final Widget child; // Render the current page
  final ThemeMode themeMode;

  const MobileLayout({
    required this.child,
    required this.themeMode,
    super.key,
  });

  @override
  State<MobileLayout> createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  @override
  void initState() {
    super.initState();
    // Theme is now initialized in ThemeCubit constructor
  }

  Future<void> _pickAndUploadFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['wav', 'jpg', 'jpeg', 'txt'],
    );

    if (!mounted) return;

    if (result != null) {
      List<String> files = result.paths.whereType<String>().toList();
      if (files.isNotEmpty) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return BlocProvider.value(
              value: context.read<FileUploadCubit>(),
              child: FileUploadDialog(files: files),
            );
          },
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No files selected.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _getCurrentIndex(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _pickAndUploadFiles,
        backgroundColor: widget.themeMode == ThemeMode.light ? Colors.white : Colors.black,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
        child: Icon(Icons.add, color: widget.themeMode == ThemeMode.light ? Colors.black : Colors.white),
      ),
      appBar: AppBar(
        title: const Text("SMSE" , style: TextStyle(fontSize: 24 , fontWeight: FontWeight.bold)),
        actions: [
          BlocBuilder<ThemeCubit, ThemeMode>(
            builder: (context, currentThemeMode) {
              return IconButton(
                icon: Icon(
                  currentThemeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              );
            },
          ),
        ],
      ),
      body: widget.child,
      bottomNavigationBar: FancyBottomNavigationPlus(
        initialSelection: currentIndex,
        shadowRadius: 10,
        circleColor: context.watch<ThemeCubit>().state == ThemeMode.light ? Colors.white : Colors.black,
        onTabChangedListener: (index) {
          switch (index) {
            case 0:
              context.go('/home');
              break;
            case 1:
              context.go('/favorites');
              break;
            case 2:
              context.go('/profile');
              break;
          }
        },
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: context.watch<ThemeCubit>().state == ThemeMode.light ? Colors.black : Colors.white,
        ),
        tabs: [
          TabData(icon: const Icon(Icons.home), title: "Home"),
          TabData(icon: const Icon(Icons.favorite), title: "Favorites"),
          TabData(icon: const Icon(Icons.person), title: "Profile"),
        ],
      ),
    );
  }

  int _getCurrentIndex(BuildContext context) {
    final location = GoRouter.of(context).state!.uri.toString();
    switch (location) {
      case '/home':
        return 0;
      case '/favorites':
        return 1;
      case '/profile':
        return 2;
      default:
        return 0;
    }
  }
}
