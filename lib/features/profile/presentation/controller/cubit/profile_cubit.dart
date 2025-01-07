import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/profile/data/repositories/profile_repo.dart';
import 'package:smse/features/profile/presentation/controller/cubit/profile_state.dart';

class ProfileCubit extends Cubit<ProfileState>{
  final ProfileRepository profileRepository;
  ProfileCubit(this.profileRepository) : super(ProfileInitialState());
  Future<void>fetchUser()async{
    emit(ProfileLoadingState());

      final user= await profileRepository.fetchUserData();

    user.fold(
          (failure) {
        emit(ProfileErrorState(failure.errMessage));
      },
          (userData) {
        emit(ProfileSuccessState(userData));
      },
    );
  }

}