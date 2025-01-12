import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/mainPage/model/content.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_state.dart';
class ContentWebPage extends StatelessWidget {
  const ContentWebPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ContentCubit, ContentState>(
      builder: (context, state) {
        if (state is ContentLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is ContentError) {
          return Center(child: Text(state.message));
        } else if (state is ContentLoaded) {
          return GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
            ),
            padding: const EdgeInsets.all(16.0),
            itemCount: state.contents.length,
            itemBuilder: (context, index) {
              final content = state.contents[index];
              return Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        content.content_path.split('/').last,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 8),
                      Text(content.content_tag ? "Tagged" : "Not Tagged"),
                      const Spacer(),
                      buildActions(context, content),
                    ],
                  ),
                ),
              );
            },
          );
        }
        return const Center(child: Text('No contents available.'));
      },
    );
  }

  Widget buildActions(BuildContext context, ContentModel content) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.download),
          onPressed: () {
            context.read<ContentCubit>().downloadFile(content.id ?? 0);
          },
        ),
        IconButton(
          icon: const Icon(Icons.delete),
          onPressed: () {
            _showDeleteDialog(context, content);
          },
        ),
      ],
    );
  }

  // Function to show the confirmation dialog before deletion
  void _showDeleteDialog(BuildContext context, ContentModel content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Content'),
          content: const Text('Are you sure you want to delete this content?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                context.read<ContentCubit>().deleteContent(content.id ?? 0);
                Navigator.of(context).pop(); // Close the dialog after deletion
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
