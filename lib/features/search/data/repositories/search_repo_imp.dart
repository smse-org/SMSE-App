import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';


class SearchRepositoryImpl implements SearchRepository {

  final ApiService apiService;

  SearchRepositoryImpl(this.apiService);

  @override
  Future<Either<Faliuer, List<SearchResult>>> searchFiles(
    String query, {
    int? limit,
    List<String>? modalities,
  }) async {
    try {
      final Map<String, dynamic> data = {"query": query};
      
      if (limit != null) {
        data["limit"] = limit;
      }
      
      if (modalities != null && modalities.isNotEmpty) {
        data["modalities"] = modalities;
      }

      final response = await apiService.post(
        endpoint: Constant.searchEndpoint,
        data: jsonEncode(data),
        token: true,
      );

      // Ensure 'results' exists and is a list
      if (response["results"] is! List) {
        return Left(ServerFailuer("Invalid response format from server"));
      }

      final results = response["results"] as List;
      final searchResults = results.map((result) =>
          SearchResult.fromJson(result)).toList();

      return Right(searchResults);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Faliuer, List<SearchQuery>>> queries() async {
    try {
      final response = await apiService.get(endpoint: Constant.searchEndpoint);

      if (response is! Map<String, dynamic>) {
        return Left(ServerFailuer("Invalid response format fro server"));
      }

      if (response['queries'] is! List) {
        return Left(ServerFailuer("Invalid queries format from server"));
      }

      final queriesList = response['queries'] as List;
      final queries = queriesList
          .map((data) => SearchQuery.fromJson(data as Map<String, dynamic>))
          .toList();

      return Right(queries);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Faliuer, String>> deleteQuery(int id) async{
    try{
      final response = await apiService.delete(
        endpoint: "${Constant.searchEndpoint}/$id",
      );

      if (response["message"] is String) {
        return Right(response["message"]);
      } else {
        return Left(ServerFailuer("Invalid response format from server"));
      }

    }on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }


  

}