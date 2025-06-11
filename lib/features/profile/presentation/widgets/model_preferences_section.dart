import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/core/components/custom_button.dart';
import 'package:smse/features/profile/data/models/user_preferences.dart';
import 'package:smse/features/profile/presentation/controller/cubit/preferences_cubit.dart';

class ModelPreferencesSection extends StatefulWidget {
  const ModelPreferencesSection({Key? key}) : super(key: key);

  @override
  State<ModelPreferencesSection> createState() => _ModelPreferencesSectionState();
}

class _ModelPreferencesSectionState extends State<ModelPreferencesSection> {
  String? selectedTextModel;
  String? selectedImageModel;
  String? selectedAudioModel;

  final List<String> textModels = [
    'ImageBind',
    'All-MiniLM',
    'All-mpnet',
    'CLIP',
  ];

  final List<String> imageModels = [
    'ImageBind',
    'CLIP'
  ];

  final List<String> audioModels = [
   'ImageBind',
  ];

  @override
  void initState() {
    super.initState();
    context.read<PreferencesCubit>().loadPreferences();
  }

  void _savePreferences() {
    final preferences = UserPreferences(
      textModel: selectedTextModel,
      imageModel: selectedImageModel,
      audioModel: selectedAudioModel,
    );
    context.read<PreferencesCubit>().updatePreferences(preferences);
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PreferencesCubit, PreferencesState>(
      listener: (context, state) {
        if (state is PreferencesLoaded) {
          setState(() {
            selectedTextModel = state.preferences.textModel;
            selectedImageModel = state.preferences.imageModel;
            selectedAudioModel = state.preferences.audioModel;
          });
        } else if (state is PreferencesError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error: ${state.message}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      },
      builder: (context, state) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Model Preferences',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            
            // Text Models Selection
            const Text(
              'Text Models',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedTextModel,
                  isExpanded: true,
                  hint: const Text('Select Text Model'),
                  items: textModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedTextModel = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Image Models Selection
            const Text(
              'Image Models',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedImageModel,
                  isExpanded: true,
                  hint: const Text('Select Image Model'),
                  items: imageModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedImageModel = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Audio Models Selection
            const Text(
              'Audio Models',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedAudioModel,
                  isExpanded: true,
                  hint: const Text('Select Audio Model'),
                  items: audioModels.map((String model) {
                    return DropdownMenuItem<String>(
                      value: model,
                      child: Text(model),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedAudioModel = newValue;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Save Button
            Center(
              child: state is PreferencesLoading
                  ? const CircularProgressIndicator()
                  : CustomButton(
                      onPressed: _savePreferences,

                      color: Theme.of(context).primaryColor,
                      text: 'Save Preferences',
                      colorText: Colors.white,
                    ),
            ),
          ],
        );
      },
    );
  }
} 