import 'package:bloc/bloc.dart';
import 'package:smse/features/profile/data/repositories/logout/logout_repo.dart';
import 'package:smse/features/profile/presentation/controller/cubit/logoutCubit/logout_state.dart';

class LogoutCubit extends Cubit<LogoutState>{
  final LogoutRepo logoutRepo;
  LogoutCubit(this.logoutRepo) : super(LogoutInitial());

  void logout() async{
    emit(const LogoutLoading());
    final logout= await logoutRepo.logout();
    logout.fold(
          (failure) {
        emit(LogoutFailure(failure.errMessage));
      },
          (userData) {
        emit(const LogoutSuccess());
      },
    );
}}