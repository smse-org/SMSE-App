import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo.dart';
import 'package:smse/features/auth/signup/data/repositories/signup_repo_imp.dart';

final getIt = GetIt.instance;

void setupServiceLocator(){
  getIt.registerSingleton<ApiService>(ApiService(Dio()));
  getIt.registerSingleton<SignUpRepo>(SignUpRepoImp(
    getIt.get<ApiService>(),
  )
  );

}