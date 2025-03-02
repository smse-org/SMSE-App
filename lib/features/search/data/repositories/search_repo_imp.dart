import 'dart:convert';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:smse/constants.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/core/network/api/api_service.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';


class SearchRepositoryImpl implements SearchRepository {

  final ApiService apiService;

  SearchRepositoryImpl(this.apiService);

  @override
  Future<Either<Faliuer, List<SearchResult>>> searchFiles(String query) async {
    try {
      final response = await apiService.post(
        endpoint: Constant.searchEndpoint,
        data: jsonEncode({"query": query}),
        token: true,
      );

      if (response == null) {
        return Left(ServerFailuer("No response from server"));
      }

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
}