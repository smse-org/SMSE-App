import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/profile/data/models/user_preferences.dart';
import 'package:smse/features/profile/data/repositories/preferences_repository.dart';

// Events
abstract class PreferencesEvent {}

class LoadPreferences extends PreferencesEvent {}

class UpdatePreferences extends PreferencesEvent {
  final UserPreferences preferences;

  UpdatePreferences(this.preferences);
}

// States
abstract class PreferencesState {}

class PreferencesInitial extends PreferencesState {}

class PreferencesLoading extends PreferencesState {}

class PreferencesLoaded extends PreferencesState {
  final UserPreferences preferences;

  PreferencesLoaded(this.preferences);
}

class PreferencesError extends PreferencesState {
  final String message;

  PreferencesError(this.message);
}

// Cubit
class PreferencesCubit extends Cubit<PreferencesState> {
  final PreferencesRepository _repository;

  PreferencesCubit(this._repository) : super(PreferencesInitial());

  Future<void> loadPreferences() async {
    emit(PreferencesLoading());
    try {
      final preferences = await _repository.getUserPreferences();
      emit(PreferencesLoaded(preferences));
    } catch (e) {
      print(e.toString());
      emit(PreferencesError(e.toString()));
    }
  }

  Future<void> updatePreferences(UserPreferences preferences) async {
    emit(PreferencesLoading());
    try {
      await _repository.updateUserPreferences(preferences);
      emit(PreferencesLoaded(preferences));
    } catch (e) {
      emit(PreferencesError(e.toString()));
    }
  }

  Future<void> updateAudioModel(String model) async {
    try {
      final currentState = state;
      if (currentState is PreferencesLoaded) {
        final updatedPreferences = currentState.preferences.copyWith(audioModel: model);
        await updatePreferences(updatedPreferences);
      }
    } catch (e) {
      emit(PreferencesError(e.toString()));
    }
  }

  Future<void> updateImageModel(String model) async {
    try {
      final currentState = state;
      if (currentState is PreferencesLoaded) {
        final updatedPreferences = currentState.preferences.copyWith(imageModel: model);
        await updatePreferences(updatedPreferences);
      }
    } catch (e) {
      emit(PreferencesError(e.toString()));
    }
  }

  Future<void> updateTextModel(String model) async {
    try {
      final currentState = state;
      if (currentState is PreferencesLoaded) {
        final updatedPreferences = currentState.preferences.copyWith(textModel: model);
        await updatePreferences(updatedPreferences);
      }
    } catch (e) {
      emit(PreferencesError(e.toString()));
    }
  }
} 