// repositories/search_repository.dart
import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';
import 'package:smse/features/search/data/model/search_results.dart';

abstract class SearchRepository {
  Future<Either<Faliuer, List<SearchResult>>> searchFiles(String query);
}