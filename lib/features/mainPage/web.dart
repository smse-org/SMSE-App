import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart'; // For kIsWeb check
import 'package:smse/constants.dart';
import 'package:smse/features/favourite/presentation/screen/favourite_page.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';

class WebLayout extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const WebLayout({super.key, required this.toggleTheme, required this.themeMode});

  @override
  _WebLayoutState createState() => _WebLayoutState();
}

class _WebLayoutState extends State<WebLayout> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    const FavoritesPage(),
    ProfilePage(),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _searchAndUploadFiles() async {
    // Open file picker
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      if (kIsWeb) {
        // Web-specific handling: use bytes instead of paths
        List<Uint8List> filesInBytes = result.files.map((file) => file.bytes!).toList();
        // Show a dialog with a linear progress bar
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return FileUploadDialog(files: filesInBytes);
          },
        );
      } else {
        // For non-web platforms, use paths
        List<String> files = result.paths.whereType<String>().toList();
        // Show a dialog with a linear progress bar
        showDialog(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) {
            return FileUploadDialog(files: files);
          },
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No files selected.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _searchAndUploadFiles,
        child: const Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
      appBar: AppBar(
        leading: Image.asset(Constant.logoImage),
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
        title: const Text("SMSE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.home), text: "Home"),
            Tab(icon: Icon(Icons.search), text: "Search"),
            Tab(icon: Icon(Icons.favorite), text: "Favorites"),
            Tab(icon: Icon(Icons.person), text: "Profile"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: _pages,
      ),
    );
  }
}

class FileUploadDialog extends StatefulWidget {
  final List<dynamic> files; // Can be either String (path) or Uint8List (bytes)

  const FileUploadDialog({Key? key, required this.files}) : super(key: key);

  @override
  _FileUploadDialogState createState() => _FileUploadDialogState();
}

class _FileUploadDialogState extends State<FileUploadDialog> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _startUploading();
  }

  Future<void> _startUploading() async {
    for (int i = 0; i < widget.files.length; i++) {
      await Future.delayed(const Duration(seconds: 1)); // Simulate upload delay
      if (mounted) {
        setState(() {
          progress = ((i + 1) / widget.files.length) * 100;
        });
      }
    }

    if (mounted) {
      // Close the dialog when upload is complete
      Navigator.pop(context);
      // Show a completion message
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("All files uploaded successfully!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
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
        if (progress < 100)
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Allow user to cancel upload
            },
            child: const Text("Cancel"),
          ),
      ],
    );
  }
}
