import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository repository;
  final List<String> _selectedModalities = [];
  int? _limit;
  List<SearchQuery> _recentQueries = [];

  SearchCubit(this.repository) : super(SearchInitial());

  Future<void> searchWithText(
    String query, {
    int? limit,
    List<String>? modalities,
  }) async {
    emit(SearchLoading());
    final result = await repository.searchWithText(
      query,
      limit: limit,
      modalities: modalities,
    );
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (results) => emit(SearchSucsess(results)),
    );
  }

  Future<void> searchWithFiles(
    List<String> files, {
    String? query,
    int? limit,
    List<String>? modalities,
  }) async {
    emit(SearchLoading());
    final result = await repository.searchWithFiles(
      files,
      query: query,
      limit: limit,
      modalities: modalities,
    );
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (results) => emit(SearchSucsess(results)),
    );
  }

  Future<void> searchQueries() async {
    emit(SearchLoading());
    final result = await repository.queries();
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (queries) => emit(QueriesSuccess(queries)),
    );
  }

  Future<void> deleteQuery(int id) async {
    emit(SearchLoading());
    final result = await repository.deleteQuery(id);
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (_) => searchQueries(),
    );
  }

  void toggleModality(String modality) {
    if (_selectedModalities.contains(modality)) {
      _selectedModalities.remove(modality);
    } else {
      _selectedModalities.add(modality);
    }
    // Emit both states to ensure proper rebuild
    emit(ModalityChanged(_selectedModalities));
    emit(SearchInitial());
  }

  // Method to set search limit
  void setLimit(int limit) {
    _limit = limit;
  }

  // Getter for selected modalities
  List<String> get selectedModalities => _selectedModalities;
}



