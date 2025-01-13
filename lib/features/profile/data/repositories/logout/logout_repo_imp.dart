
import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/profile/data/repositories/logout/logout_repo.dart';

class LogoutRepoImp extends LogoutRepo{
  final ApiService apiService;

  LogoutRepoImp(this.apiService);

  @override
  Future<Either<Faliuer, void>> logout() async{
   try{
      await apiService.post(endpoint: "auth/logout", data: null, token: true);
      return const Right(null);
     
   }catch (e){
     return Left(ServerFailuer(e.toString()));
   }
  }

}