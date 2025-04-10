import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/model/profile_data.dart';
import 'package:smse/features/profile/data/repositories/profile_repo.dart';

class ProfilRepoImp extends ProfileRepository {
  final ApiService apiService;

  ProfilRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, ProfileData>> fetchUserData() async{
    try{
      final response = await apiService.get(endpoint: Constant.profileEndpoint);
      return Right(ProfileData.fromJson(response));
    }on DioException catch(e){
      return Left(ServerFailuer.fromDioError(e));
    }catch(e){
      return Left(ServerFailuer(e.toString()));
    }

  }


}
