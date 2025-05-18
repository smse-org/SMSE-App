import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:lottie/lottie.dart';
import 'package:file_picker/file_picker.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/repo/file_upload_repo_imp.dart';
import 'package:smse/features/mainPage/widget/file_upload_progress_page.dart';

class SearchAnimationPage extends StatefulWidget {
  const SearchAnimationPage({super.key});

  @override
  SearchAnimationPageState createState() => SearchAnimationPageState();
}

class SearchAnimationPageState extends State<SearchAnimationPage> {
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
        // Show upload progress dialog
        showDialog(
          context: context,
          barrierDismissible: false, // Prevent dismissal while uploading
          builder: (_) => BlocProvider(
            create: (_) => FileUploadCubit(FileUploadRepoImp(ApiService(Dio()))),
            child: FileUploadProgressDialog(files: files),
          ),
        );
      }
    } else if (mounted) {
      // Go back to the previous page if no file is selected
      GoRouter.of(context).pop();
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
