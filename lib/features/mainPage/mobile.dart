import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';
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

    if (result != null && result.files.isNotEmpty) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return BlocProvider.value(
            value: context.read<FileUploadCubit>(),
            child: FileUploadDialog(files: result.files),
          );
        },
      );
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

class FileUploadDialog extends StatefulWidget {
  final List<dynamic> files; // Can be either String (path) or Uint8List (bytes)

  const FileUploadDialog({super.key, required this.files});

  @override
  FileUploadDialogState createState() => FileUploadDialogState();
}

class FileUploadDialogState extends State<FileUploadDialog> {
  @override
  void initState() {
    super.initState();
    _startUploading();
  }

  Future<void> _startUploading() async {
    // For desktop/mobile platforms
    final filePaths = widget.files.whereType<String>().toList();
    if (filePaths.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No valid files selected")),
      );
      Navigator.pop(context);
      return;
    }

    // Get the FileUploadCubit from the context
    final fileUploadCubit = context.read<FileUploadCubit>();
    // Start the upload
    await fileUploadCubit.uploadFiles(filePaths);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FileUploadCubit, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files uploaded successfully!")),
          );
        } else if (state is FileUploadFailure) {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Upload failed: {state.error}")),
          );
        }
      },
      child: BlocBuilder<FileUploadCubit, FileUploadState>(
        builder: (context, state) {
          double progress = 0.0;
          if (state is FileUploadInProgress) {
            progress = (state.progress! * 100).toDouble();
          }

          return AlertDialog(
            title: const Text("Uploading Files"),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Uploading... ${progress.toStringAsFixed(0)}%",
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                LinearProgressIndicator(
                  value: progress / 100,
                  minHeight: 10,
                  backgroundColor: Colors.grey[300],
                  color: Colors.blue,
                ),
                const SizedBox(height: 20),
                Text(
                  "File ${((progress / 100) * widget.files.length).ceil()} of ${widget.files.length}",
                  style: const TextStyle(fontSize: 16),
                ),
              ],
            ),
            actions: [
              if (state is! FileUploadSuccess)
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("Cancel"),
                ),
            ],
          );
        },
      ),
    );
  }
}
