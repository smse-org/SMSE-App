import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/core/utililes/cachedSP.dart';
import 'package:smse/features/auth/login/data/model/user.dart';
import 'package:smse/features/auth/login/data/repositories/loginrepo.dart';

class LoginRepoImp extends LoginRepo{
  final ApiService apiService;

  LoginRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, String>> login(UserModel userModel) async {
    try {
      final response = await apiService.post(endpoint: Constant.loginEndpoint, data: userModel.toJson(),token:false);
      final token = response['access_token'];
      final refreshToken = response['refresh_token'];


      CachedData.storeData(Constant.accessToekn, token);
      CachedData.storeData(Constant.refreshToken, refreshToken);


      return Right(token);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}