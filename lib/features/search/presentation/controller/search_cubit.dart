import 'package:bloc/bloc.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;
  List<String> _selectedModalities = [];
  int? _limit;
  List<SearchQuery> _recentQueries = [];

  SearchCubit(this.searchRepository) : super(SearchInitial());

  // Method to search with a query
  void search(String query) async {
    if (query.trim().isEmpty) return;
    
    emit(SearchLoading());
    final result = await searchRepository.searchFiles(
      query,
      limit: _limit,
      modalities: _selectedModalities.isNotEmpty ? _selectedModalities : null,
    );
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (searchResults) {
        // Filter results based on selected modalities if any are selected
        if (_selectedModalities.isNotEmpty) {
          final filteredResults = searchResults.where((result) => 
            _selectedModalities.contains(result.contentType)
          ).toList();
          emit(SearchSucsess(filteredResults));
        } else {
          emit(SearchSucsess(searchResults));
        }
      },
    );
  }

  // Method to set initial search results
  void setSearchResults(List<SearchResult> results) {
    if (_selectedModalities.isNotEmpty) {
      final filteredResults = results.where((result) => 
        _selectedModalities.contains(result.contentType)
      ).toList();
      emit(SearchSucsess(filteredResults));
    } else {
      emit(SearchSucsess(results));
    }
  }

  // Method to set search limit
  void setLimit(int limit) {
    _limit = limit;
  }

  // Method to toggle modality selection
  void toggleModality(String modality) {
    if (_selectedModalities.contains(modality)) {
      _selectedModalities.remove(modality);
    } else {
      _selectedModalities.add(modality);
    }
    // Emit a new state to trigger UI update
    emit(ModalityChanged(List.from(_selectedModalities)));
  }

  // Method to clear modality selection
  void clearModalities() {
    _selectedModalities.clear();
    // Emit a new state to trigger UI update
    emit(ModalityChanged([]));
  }

  // Method to get currently selected modalities
  List<String> get selectedModalities => _selectedModalities;

  Future<void> searchQueries() async {
    emit(SearchLoading());
    final result = await searchRepository.queries();
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (queries) {
        _recentQueries = queries;
        emit(QueriesSuccess(queries));
      }
    );
  }

  Future<void> deleteQuery(int id) async {
    emit(SearchLoading());
    final result = await searchRepository.deleteQuery(id);
    result.fold(
      (failure) => emit(SearchError(failure.errMessage)),
      (message) {
        _recentQueries.removeWhere((query) => query?.id == id);
        emit(DeleteQuerySuccess(message));
        // Re-emit queries state to update UI
        emit(QueriesSuccess(_recentQueries));
      },
    );
  }
}


