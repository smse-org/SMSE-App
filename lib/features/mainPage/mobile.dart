import 'package:fancy_bottom_navigation_plus/fancy_bottom_navigation_plus.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/features/favourite/presentation/screen/favourite_page.dart';
import 'package:smse/features/home/presentation/screen/homapage.dart';
import 'package:smse/features/profile/presentation/screen/profile_page.dart';
import 'package:smse/features/search/presentation/screen/search_page.dart';

class MobileLayout extends StatefulWidget {
  final VoidCallback toggleTheme;
  final ThemeMode themeMode;

  const MobileLayout({super.key, required this.toggleTheme, required this.themeMode});

  @override
  _MobileLayoutState createState() => _MobileLayoutState();
}

class _MobileLayoutState extends State<MobileLayout> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    SearchPage(),
    const FavoritesPage(),
    ProfilePage(),
  ];

  Future<void> _searchFiles() async {
    // Request storage permissions
    if (await Permission.storage.request().isGranted) {
      // Navigate to the search animation page
      await Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (context, animation, secondaryAnimation) => const SearchAnimationPage(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset(0.0, 0.0);
            const curve = Curves.easeInOut;

            var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        ),
      );
    } else {
      // Permission denied
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Storage permission is required to search files.")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _searchFiles,
        backgroundColor: Colors.blue,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(80),
        ),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        title: const Text("SMSE", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        actions: [
          IconButton(
            icon: Icon(widget.themeMode == ThemeMode.light ? Icons.dark_mode : Icons.light_mode),
            onPressed: widget.toggleTheme,
          ),
        ],
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: FancyBottomNavigationPlus(
        initialSelection: _currentIndex,
        shadowRadius: 10,
        circleColor: widget.themeMode == ThemeMode.light ? Colors.white : Colors.black,
        onTabChangedListener: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        tabs: [
          TabData(icon: const Icon(Icons.home), title: "Home"),
          TabData(icon: const Icon(Icons.search), title: "Search"),
          TabData(icon: const Icon(Icons.favorite), title: "Favorites"),
          TabData(icon: const Icon(Icons.person), title: "Profile"),
        ],
      ),
    );
  }
}

class SearchAnimationPage extends StatefulWidget {
  const SearchAnimationPage({Key? key}) : super(key: key);

  @override
  _SearchAnimationPageState createState() => _SearchAnimationPageState();
}

class _SearchAnimationPageState extends State<SearchAnimationPage> {
  @override
  void initState() {
    super.initState();
    _startFileSearch();
  }

  Future<void> _startFileSearch() async {
    await Future.delayed(const Duration(seconds: 5)); // Simulate search animation delay

    // Open file picker directly
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      // If files are selected, navigate to upload progress page
      List<String> files = result.paths.whereType<String>().toList();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => FileUploadProgressPage(files: files),
          ),
        );
      }
    } else {
      // If no files selected, return to the previous page
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Searching Files"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset(
              'assets/animation/searching.json',
              width: 200,
              height: 200,
            ),
            const SizedBox(height: 20),
            const Text(
              "Searching for files...",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class FileUploadProgressPage extends StatefulWidget {
  final List<String> files;

  const FileUploadProgressPage({Key? key, required this.files}) : super(key: key);

  @override
  _FileUploadProgressPageState createState() => _FileUploadProgressPageState();
}

class _FileUploadProgressPageState extends State<FileUploadProgressPage> {
  double progress = 0;

  @override
  void initState() {
    super.initState();
    _uploadFiles();
  }

  Future<void> _uploadFiles() async {
    for (int i = 0; i < widget.files.length; i++) {
      await Future.delayed(const Duration(seconds: 5)); // Simulate upload delay
      setState(() {
        progress = ((i + 1) / widget.files.length) * 100;
      });
    }

    // Navigate back or show completion message after all uploads are done
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("All files uploaded successfully!")),
    );
    Navigator.pop(context); // Return to the previous page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Uploading Files"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Uploading... ${progress.toStringAsFixed(0)}%",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            LinearProgressIndicator(
              value: progress / 100, // Value between 0.0 and 1.0
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
      ),
    );
  }
}
