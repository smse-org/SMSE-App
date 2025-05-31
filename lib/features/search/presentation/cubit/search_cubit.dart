import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/model/search_query.dart';
import '../../data/repositories/search_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:smse/core/error/failuers.dart';

part 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository _searchRepository;

  SearchCubit({required SearchRepository searchRepository})
      : _searchRepository = searchRepository,
        super(SearchInitial());

  List<SearchQuery> _searchQueries = [];
  bool _hasMore = true;

  Future<void> loadSearchQueries() async {
    if (!_hasMore) return;

    try {
      emit(SearchLoading());
      final result = await _searchRepository.queries();
      
      result.fold(
        (failure) => emit(SearchError(message: failure.toString())),
        (queries) {
          _searchQueries = queries.cast<SearchQuery>();
          _hasMore = queries.isNotEmpty;
          emit(SearchLoaded(
            queries: _searchQueries,
            hasMore: _hasMore,
          ));
        },
      );
    } catch (e, stackTrace) {
      print('Error in loadSearchQueries: $e');
      print('Stack trace: $stackTrace');
      emit(SearchError(message: e.toString()));
    }
  }

  // Future<void> addSearchQuery(String text) async {
  //   try {
  //     emit(SearchLoading());
  //     final newQuery = await _searchRepository.addSearchQuery(text);
  //
  //     _searchQueries.insert(0, newQuery);
  //     emit(SearchLoaded(
  //       queries: _searchQueries,
  //       hasMore: _hasMore,
  //     ));
  //   } catch (e) {
  //     print('Error in addSearchQuery: $e');
  //     emit(SearchError(message: e.toString()));
  //   }
  // }

  Future<void> deleteSearchQuery(int id) async {
    try {
      emit(SearchLoading());
      final result = await _searchRepository.deleteQuery(id);
      
      result.fold(
        (failure) => emit(SearchError(message: failure.toString())),
        (_) {
          _searchQueries.removeWhere((query) => query.id == id);
          emit(SearchLoaded(
            queries: _searchQueries,
            hasMore: _hasMore,
          ));
        },
      );
    } catch (e) {
      print('Error in deleteSearchQuery: $e');
      emit(SearchError(message: e.toString()));
    }
  }

  void clearSearchQueries() {
    _searchQueries.clear();
    _hasMore = true;
    emit(SearchInitial());
  }
} 