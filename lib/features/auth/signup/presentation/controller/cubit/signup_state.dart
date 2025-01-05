import 'package:equatable/equatable.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';

abstract class SignUpState extends Equatable {
  const SignUpState();

  @override
  List<Object> get props => [];
}


class SignupInitialState extends SignUpState{

}

class SignupLoadingState extends SignUpState{

}
class SignupSuccessState extends SignUpState{
final SignupModel signupModel;
const SignupSuccessState({required this.signupModel});
  @override
  List<Object> get props => [signupModel];
}
class SignupFailureState extends SignUpState{
  final String message;
  const SignupFailureState({required this.message});
  @override
  List<Object> get props => [message];
}