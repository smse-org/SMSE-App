import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo.dart';

class SignUpRepoImp extends SignUpRepo {
  final ApiService apiService;

  SignUpRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, SignupModel>> signUp(SignupModel signupModel) async {
    try {
      final response = await apiService.post(
        endpoint: Constant.registerEndpoint,
        data: signupModel.toJson(),
        token: false,
      );

      if (response['msg'] == 'User created successfully') {
        // ✅ Instead of parsing a user model from the response, just return the original signupModel
        return Right(signupModel);
      }
      return Left(ServerFailuer(response['msg'] ?? 'Signup failed'));
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}