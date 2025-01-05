import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
import 'package:smse/features/auth/login/data/repositories/loginrepo.dart';
import 'package:smse/features/auth/login/presentation/controller/cubit/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginRepo loginRepo;

  LoginCubit(this.loginRepo) : super(LoginInitialState());

  Future<void> login(UserModel usermodel) async {
    emit(LoginLoadingState());

    final result = await loginRepo.login(usermodel);

    result.fold(
          (failure) => emit(LoginFailureState(failure.errMessage)),
          (token) => emit(LoginSuccessState(token)),
    );
  }
}