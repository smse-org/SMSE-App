import 'package:equatable/equatable.dart';
import 'package:smse/features/profile/data/model/profile_data.dart';

abstract class ProfileState extends Equatable{
  const ProfileState();
  @override
  List<Object> get props => [];
}


class ProfileInitialState extends ProfileState{

}

class ProfileLoadingState extends ProfileState{

}

class ProfileSuccessState extends ProfileState{
final ProfileData userData;
  const ProfileSuccessState(this.userData);
}

class ProfileErrorState extends ProfileState{
  final String message;
  const ProfileErrorState(this.message);
}