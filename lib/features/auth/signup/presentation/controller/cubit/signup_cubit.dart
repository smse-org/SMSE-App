import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/auth/signup/data/model/user_model.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo.dart';
import 'package:smse/features/auth/signup/presentation/controller/cubit/signup_state.dart';

class SignupCubit extends Cubit<SignUpState> {
  final SignUpRepo signUpRepo;

  SignupCubit(this.signUpRepo) : super(SignupInitialState());

  Future<void> signup(SignupModel data) async {
    emit(SignupLoadingState());

    final result = await signUpRepo.signUp(data);
    result.fold(
          (failure) => emit(SignupFailureState(message: failure.errMessage)),
          (signupModel) => emit(SignupSuccessState(signupModel: signupModel)),
    );
  }
}
