import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/auth/signup/data/model/userModel.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo.dart';

class SignUpRepoImp extends SignUpRepo {
  final ApiService apiService;

  SignUpRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, SignupModel>> signUp(SignupModel signupModel) async{
    try {
      var resp = await apiService.post(endpoint: "register", data: signupModel.toJson());
      if (resp['msg'] != null) {
        if (resp['msg'] == 'User created successfully') {
          SignupModel signupResponse = SignupModel.fromJson(resp);
          return Right(signupResponse);
        } else {
          return Left(ServerFailuer(resp['msg']));
        }
      }



      return Left(ServerFailuer('Unknown error occurred'));

    } on DioException catch (e) {
      // Handle Dio errors
      return Left(ServerFailuer(e.response?.data['msg'] ?? 'Error during request'));
    } catch (e) {
      // Handle other exceptions
      return Left(ServerFailuer(e.toString()));
    }
  }
}

