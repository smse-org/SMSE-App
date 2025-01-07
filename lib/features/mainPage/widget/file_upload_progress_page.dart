import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/mainPage/controller/file_cubit.dart';
import 'package:smse/features/mainPage/controller/file_state.dart';

class FileUploadProgressDialog extends StatelessWidget {
  final List<String> files;

  const FileUploadProgressDialog({Key? key, required this.files}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    context.read<FileUploadCubit>().uploadFiles(files);

    return BlocListener<FileUploadCubit, FileUploadState>(
      listener: (context, state) {
        if (state is FileUploadSuccess) {
          Navigator.pop(context); // Close dialog on success
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Files uploaded successfully!")),
          );
        } else if (state is FileUploadFailure) {
          print("Error: ${state.error}");
          Navigator.pop(context); // Close dialog on failure
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