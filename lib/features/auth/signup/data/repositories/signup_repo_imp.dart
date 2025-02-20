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
  Future<Either<Faliuer, SignupModel>> signUp(SignupModel signupModel) async{
    try {
      var resp = await apiService.post(endpoint: Constant.registerEndpoint, data: signupModel.toJson(),token:false);
      if (resp['msg'] != null) {
        if (resp['msg'] == 'User created successfully') {
          SignupModel signupResponse = SignupModel.fromJson(resp);
          return Right(signupResponse);
        } else {
          return Left(ServerFailuer(resp['msg']));
        }
      }



      return Left(ServerFailuer('Unknown error occurred'));

    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}

