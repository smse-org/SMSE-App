import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:smse/core/routes/app_router.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';

class FileUploadProgressDialog extends StatelessWidget {
  final List<String> files;

  const FileUploadProgressDialog({super.key, required this.files});

  @override
  Widget build(BuildContext context) {
    context.read<FileUploadCubit>().uploadFiles(files);

    return BlocListener<FileUploadCubit, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files uploaded successfully!")),
          );
          GoRouter.of(context).pushReplacement(AppRouter.home);
        } else if (state is FileUploadFailure) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text("Error: ${state.error}"),
              backgroundColor: Colors.red,
            ),
          );
          GoRouter.of(context).pushReplacement(AppRouter.home);
        }
      },
      child: AlertDialog(
        title: const Text("Uploading Files"),
        content: BlocBuilder<FileUploadCubit, FileUploadState>(
          builder: (context, state) {
            if (state is FileUploadInProgress) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text("Uploading ${files.length} file(s)..."),
                  if (state.progress != null) ...[
                    const SizedBox(height: 8),
                    LinearProgressIndicator(value: state.progress),
                    const SizedBox(height: 4),
                    Text("${(state.progress! * 100).toInt()}%"),
                  ],
                ],
              );
            } else if (state is FileUploadFailure) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.error_outline, color: Colors.red, size: 48),
                  const SizedBox(height: 16),
                  Text(state.error, textAlign: TextAlign.center),
                ],
              );
            } else {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text("Preparing upload..."),
                ],
              );
            }
          },
        ),
        actions: [
          TextButton(
            onPressed: () => GoRouter.of(context).pushReplacement(AppRouter.home),
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }
}