import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
abstract class LoginRepo {
  Future<Either<Faliuer, String>> login(UserModel userModel);
}
