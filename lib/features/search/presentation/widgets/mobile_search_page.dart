import 'package:flutter/material.dart';
import 'package:smse/components/content_card.dart';
import 'package:smse/features/home/presentation/widgets/searchbar.dart';
import 'package:skeletonizer/skeletonizer.dart';
class MobileSearchView extends StatefulWidget {
  const MobileSearchView({super.key});

  @override
  State<MobileSearchView> createState() => _MobileSearchViewState();
}

class _MobileSearchViewState extends State<MobileSearchView> {
  bool isLoading = true; // Loading state

  @override
  void initState() {
    super.initState();
    // Simulate a delay for loading state
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
         SearchBarCustom(),
        const SizedBox(height: 20),
        _buildContentList(), // Show actual content
      ],
    );
  }

  // Skeleton Loader


  // Content List
  Widget _buildContentList() {
    return Skeletonizer(
      enabled: isLoading,
      child: ListView(
        shrinkWrap: true,
        padding: const EdgeInsets.all(8.0),
        children: const [
          ContentCardWeb(
            title: 'Beautiful Sunset Beach Photo',
            relevanceScore: 95,
          ),
          ContentCardWeb(
            title: 'Document on Black Hole Research',
            relevanceScore: 90,
          ),
        ],
      ),
    );
  }
}
