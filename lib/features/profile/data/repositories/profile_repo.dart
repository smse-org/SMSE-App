import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/profile/data/model/ProfileData.dart';

abstract class ProfileRepository {
  Future<Either<Faliuer,ProfileData>>fetchUserData();

}