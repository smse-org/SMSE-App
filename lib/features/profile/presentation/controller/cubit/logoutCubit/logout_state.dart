import 'package:equatable/equatable.dart';

abstract class LogoutState extends Equatable {
  const LogoutState();
}

class LogoutInitial extends LogoutState {
  const LogoutInitial();

  @override
  List<Object> get props => [];
}

class LogoutLoading extends LogoutState {
  const LogoutLoading();

  @override
  List<Object> get props => [];
}

class LogoutSuccess extends LogoutState {
  const LogoutSuccess();

  @override
  List<Object> get props => [];
}

class LogoutFailure extends LogoutState {
  final String message;

  const LogoutFailure(this.message);

  @override
  List<Object> get props => [message];
}