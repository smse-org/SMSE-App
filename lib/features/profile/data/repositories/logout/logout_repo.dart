import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';

abstract class LogoutRepo {
  Future<Either<Faliuer,void>> logout();
}