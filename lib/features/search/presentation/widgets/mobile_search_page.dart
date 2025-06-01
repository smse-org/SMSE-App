import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/content_card.dart';
import 'package:smse/core/components/shimmer_loading.dart';
import 'package:smse/features/previewPage/presentation/screen/preview_page.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/presentation/controller/search_cubit.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';
import 'package:smse/features/uploded_content/presentation/controller/cubit/content_cubit.dart';
import 'package:smse/features/uploded_content/presentation/screen/content_page.dart';
import 'dart:convert';
import 'dart:typed_data';

class MobileSearchView extends StatelessWidget {
  const MobileSearchView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SearchCubit, SearchState>(
      builder: (context, state) {
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              if (state is SearchLoading)
                _buildShimmerLoading()
              else if (state is SearchSucsess)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: Text(
                        key: ValueKey(state.searchResults.length),
                        'Found ${state.searchResults.length} results',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildContentList(state.searchResults),
                  ],
                )
              else if (state is SearchError)
                Center(child: Text(state.message))
              else
                const Center(child: Text('Start searching...')),
            ],
          ),
        );
      },
    );
  }

  Widget _buildShimmerLoading() {
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(8.0),
      itemCount: 5,
      itemBuilder: (context, index) {
        return ShimmerLoading(
          child: Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  ShimmerText(width: 200, height: 24),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      ShimmerCircle(size: 16),
                      SizedBox(width: 4),
                      ShimmerText(width: 60, height: 14),
                      SizedBox(width: 16),
                      ShimmerCircle(size: 16),
                      SizedBox(width: 4),
                      ShimmerText(width: 80, height: 14),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildContentList(List<SearchResult> results) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      child: ListView.builder(
        key: ValueKey(results.length),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        padding: const EdgeInsets.all(8.0),
        itemCount: results.length,
        itemBuilder: (context, index) {
          final result = results[index];
          // Convert SearchResult to ContentModel for FileViewerPage
          final content = result.toContentModel();
          return AnimatedBuilder(
            animation: Listenable.merge([
              AnimationController(
                vsync: Navigator.of(context),
                duration: Duration(milliseconds: 300 + (index * 50)),
              )..forward(),
            ]),
            builder: (context, child) {
              return FadeTransition(
                opacity: CurvedAnimation(
                  parent: AnimationController(
                    vsync: Navigator.of(context),
                    duration: Duration(milliseconds: 300 + (index * 50)),
                  )..forward(),
                  curve: Curves.easeOut,
                ),
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0, 0.1),
                    end: Offset.zero,
                  ).animate(CurvedAnimation(
                    parent: AnimationController(
                      vsync: Navigator.of(context),
                      duration: Duration(milliseconds: 300 + (index * 50)),
                    )..forward(),
                    curve: Curves.easeOut,
                  )),
                  child: Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) {
                          return FileViewerPage(
                            contentModel: content,
                          );
                        }));
                      },
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: context.read<ContentCubit>().getThumbnail(content.id!),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState == ConnectionState.waiting) {
                                return const AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: ShimmerLoading(child: ShimmerCard(width: double.infinity, height: double.infinity)),
                                ); // Shimmer for image area
                              }
                              if (snapshot.hasData && snapshot.data != null) {
                                try {
                                  final Uint8List bytes = base64Decode(snapshot.data!.split(',').last);
                                  return AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Image.memory(
                                      bytes,
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Center(child: Icon(Icons.image_not_supported, size: 64));
                                      },
                                    ),
                                  );
                                } catch (e) {
                                  print('Error decoding base64: $e');
                                  return const AspectRatio(
                                    aspectRatio: 16 / 9,
                                    child: Center(child: Icon(Icons.error, size: 64)),
                                  ); // Error icon for image area
                                }
                              }
                              return const AspectRatio(
                                aspectRatio: 16 / 9,
                                child: Center(child: Icon(Icons.image_not_supported, size: 64)),
                              ); // Fallback icon for image area
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    // Use content.contentTag for favorite icon
                                    Icon(
                                      content.contentTag ? Icons.favorite : Icons.favorite_border,
                                      size: 20,
                                      color: content.contentTag ? Colors.red : Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        content.contentPath.split('/').last, // Use content.contentPath
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Text(
                                //   'Size: ${content.contentSize} bytes', // Use content.contentSize
                                //   style: const TextStyle(fontSize: 14),
                                // ),
                                // const SizedBox(height: 4),
                                // Text(
                                //   'Upload Date: ${content.uploadDate.toString().split('.')[0]}', // Use content.uploadDate
                                //   style: const TextStyle(fontSize: 14),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}