import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';

abstract class SignUpRepo{
  Future<Either<Faliuer,SignupModel>> signUp(SignupModel signupModel);
}