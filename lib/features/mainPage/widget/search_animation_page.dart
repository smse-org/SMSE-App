import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/features/mainPage/widget/file_upload_progress_page.dart';

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

    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'png'],
    );

    if (result != null) {
      List<String> files = result.paths.whereType<String>().toList();

      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => FileUploadProgressPage(files: files),
          ),
        );
      }
    } else if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Searching Files")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Lottie.asset('assets/animation/searching.json', width: 200, height: 200),
            const SizedBox(height: 20),
            const Text("Searching for files...", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
