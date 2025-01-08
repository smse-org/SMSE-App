
abstract class LoginState {}

class LoginInitialState extends LoginState {}

class LoginLoadingState extends LoginState {}

class LoginSuccessState extends LoginState {
  final String token;

  LoginSuccessState(this.token);
}

class LoginFailureState extends LoginState {
  final String message;

  LoginFailureState(this.message);
}