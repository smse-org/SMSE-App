import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:smse/core/services/notification_settings_service.dart';

// Events
abstract class NotificationSettingsEvent extends Equatable {
  const NotificationSettingsEvent();

  @override
  List<Object> get props => [];
}

class LoadNotificationSettings extends NotificationSettingsEvent {}

class ToggleNotifications extends NotificationSettingsEvent {
  final bool enabled;

  const ToggleNotifications(this.enabled);

  @override
  List<Object> get props => [enabled];
}

// States
abstract class NotificationSettingsState extends Equatable {
  const NotificationSettingsState();

  @override
  List<Object> get props => [];
}

class NotificationSettingsInitial extends NotificationSettingsState {}

class NotificationSettingsLoading extends NotificationSettingsState {}

class NotificationSettingsLoaded extends NotificationSettingsState {
  final bool notificationsEnabled;

  const NotificationSettingsLoaded(this.notificationsEnabled);

  @override
  List<Object> get props => [notificationsEnabled];
}

class NotificationSettingsError extends NotificationSettingsState {
  final String message;

  const NotificationSettingsError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class NotificationSettingsCubit extends Cubit<NotificationSettingsState> {
  final NotificationSettingsService _settingsService;

  NotificationSettingsCubit(this._settingsService) : super(NotificationSettingsInitial());

  Future<void> loadSettings() async {
    emit(NotificationSettingsLoading());
    try {
      final enabled = await _settingsService.areNotificationsEnabled();
      emit(NotificationSettingsLoaded(enabled));
    } catch (e) {
      emit(NotificationSettingsError(e.toString()));
    }
  }

  Future<void> toggleNotifications(bool enabled) async {
    try {
      await _settingsService.setNotificationsEnabled(enabled);
      emit(NotificationSettingsLoaded(enabled));
    } catch (e) {
      emit(NotificationSettingsError(e.toString()));
    }
  }
} 