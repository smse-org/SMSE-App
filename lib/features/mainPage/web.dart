import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/constants.dart';
import 'package:smse/features/favourite/presentation/screen/favourite_page.dart';
import 'package:smse/features/home/presentation/controller/theme_cubit/theme_cubit.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';

class WebLayout extends StatefulWidget {
  const WebLayout({super.key});

  @override
  State<WebLayout> createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late PageController _pageController;
  final List<Widget> _pages = [
    const HomePage(),
    const FavoritesPage(),
    const ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _pageController = PageController();
    
    // Add listener to sync TabController with PageView
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _pageController.animateToPage(
          _tabController.index,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _searchAndUploadFiles() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['txt', 'jpg', 'jpeg', 'wav'],
      );

      if (result != null && result.files.isNotEmpty) {
        if (!mounted) return;

        final fileUploadCubit = context.read<FileUploadCubit>();
        showDialog(
          context: context,
          builder: (dialogContext) => BlocProvider.value(
            value: fileUploadCubit,
            child: FileUploadDialog(files: result.files),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking files: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeMode>(
      builder: (context, themeMode) {
        final isDark = themeMode == ThemeMode.dark;
        return Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: _searchAndUploadFiles,
            backgroundColor: isDark ? Colors.black : Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(80)),
            child: Icon(Icons.add, color: isDark ? Colors.white : Colors.black),
          ),
          appBar: AppBar(
            leading: Image.asset(Constant.logoImage),
            title: Text(
              "SMSE",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            actions: [
              IconButton(
                icon: Icon(
                  isDark ? Icons.light_mode : Icons.dark_mode,
                  color: isDark ? Colors.white : Colors.white,
                ),
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              ),
            ],
            bottom: TabBar(
              labelColor: isDark ? Colors.white : Colors.white,

              indicatorColor: isDark ? Colors.white : Colors.white,
              controller: _tabController,
              onTap: (index) {
                _pageController.animateToPage(
                  index,
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                );
              },
              tabs: [
                Tab(
                  icon: Icon(Icons.home, color: isDark ? Colors.white : Colors.white),
                  text: "Home",
                ),
                Tab(
                  icon: Icon(Icons.favorite, color: isDark ? Colors.white : Colors.white),
                  text: "Favorites",
                ),
                Tab(
                  icon: Icon(Icons.person, color: isDark ? Colors.white : Colors.white),
                  text: "Profile",
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              _tabController.animateTo(index);
            },
            children: _pages,
          ),
        );
      },
    );
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
    if (kIsWeb) {
      // For web, we need to convert Uint8List to files first
      // This is a placeholder - you'll need to implement the actual web file handling
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Web file upload not implemented yet")),
      );
      Navigator.pop(context);
      return;
    }

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
            SnackBar(content: Text("Upload failed: ${state.error}")),
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
