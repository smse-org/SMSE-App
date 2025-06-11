import 'dart:convert';
import 'dart:io';
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
  Future<Either<Faliuer, List<SearchResult>>> searchWithText(
    String query, {
    int? limit=5,
    List<String>? modalities,
  }) async {
    try {
      final Map<String, dynamic> data = {"query": query};
      
      // Build query parameters for modalities
      String endpoint = Constant.searchEndpoint;
      if (modalities != null && modalities.isNotEmpty) {
        endpoint += "?modalities=${modalities.join(',')}";
        if (limit != null) {
          endpoint += "&limit=5";
        }
      } else if (limit != null) {
        endpoint += "?limit=$limit";
      }

      final response = await apiService.post(
        endpoint: endpoint,
        data: jsonEncode(data),
        token: true,
      );

      return _processSearchResponse(response);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }

  @override
  Future<Either<Faliuer, List<SearchResult>>> searchWithFiles(
    List<String> files, {
    String? query,
    int? limit,
    List<String>? modalities,
  }) async {
    try {
      final formData = FormData();

      // Add files to form data
      for (var file in files) {
        final fileObj = File(file);
        formData.files.add(
          MapEntry(
            'files',
            await MultipartFile.fromFile(
              file,
              filename: fileObj.path.split('/').last,
            ),
          ),
        );
      }

      // Add optional query parameter
      if (query != null && query.isNotEmpty) {
        formData.fields.add(MapEntry('query', query));
      }

      // Build query parameters for modalities and limit
      String endpoint = Constant.searchEndpoint;
      if (modalities != null && modalities.isNotEmpty) {
        endpoint += "?modalities=${modalities.join(',')}";
        if (limit != null) {
          endpoint += "&limit=$limit";
        }
      } else if (limit != null) {
        endpoint += "?limit=$limit";
      }

      final response = await apiService.postContent(
        endpoint: endpoint,
        data: formData,
        token: true,
      );

      return _processSearchResponse(response);
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }

  Either<Faliuer, List<SearchResult>> _processSearchResponse(dynamic response) {
    if (response["results"] is! List) {
      return Left(ServerFailuer("Invalid response format from server"));
    }

    final results = response["results"] as List;
    final searchResults = results
        .map((result) => SearchResult.fromJson(result))
        .toList();

    return Right(searchResults);
  }

  @override
  Future<Either<Faliuer, List<SearchQuery>>> queries() async {
    try {
      final response = await apiService.get(endpoint: Constant.searchEndpoint);

      if (response is! Map<String, dynamic>) {
        return Left(ServerFailuer("Invalid response format from server"));
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
  Future<Either<Faliuer, String>> deleteQuery(int id) async {
    try {
      final response = await apiService.delete(
        endpoint: "${Constant.searchEndpoint}/$id",
      );

      if (response["message"] is String) {
        return Right(response["message"]);
      } else {
        return Left(ServerFailuer("Invalid response format from server"));
      }
    } on ServerFailuer catch (failure) {
      return Left(failure);
    } on DioException catch (dioError) {
      return Left(ServerFailuer.fromDioError(dioError));
    } catch (e) {
      return Left(ServerFailuer("Unexpected error: ${e.toString()}"));
    }
  }
}