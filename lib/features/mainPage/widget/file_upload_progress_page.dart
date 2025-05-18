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
          GoRouter.of(context).pushReplacement(AppRouter.home); // Close dialog on success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files uploaded successfully!")),
          );
        } else if (state is FileUploadFailure) {
          GoRouter.of(context).pushReplacement(AppRouter.home); // Close dialog on failure
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${state.error}")),
          );
        }
      },
      child: AlertDialog(
        title: const Text("Uploading Files"),
        content: BlocBuilder<FileUploadCubit, FileUploadState>(
          builder: (context, state) {
            if (state is FileUploadInProgress) {
              return const Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 16),
                ],
              );
            } else {
              return const Text("Preparing upload...");
            }
          },
        ),
      ),
    );
  }
}