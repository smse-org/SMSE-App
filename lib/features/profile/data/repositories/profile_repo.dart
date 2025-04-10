import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/profile/data/model/profile_data.dart';

abstract class ProfileRepository {
  Future<Either<Faliuer,ProfileData>>fetchUserData();

}