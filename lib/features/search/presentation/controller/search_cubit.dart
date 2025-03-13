import 'package:bloc/bloc.dart';
import 'package:smse/features/search/data/model/search_results.dart';
import 'package:smse/features/search/data/repositories/search_repo.dart';
import 'package:smse/features/search/presentation/controller/search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final SearchRepository searchRepository;

  SearchCubit(this.searchRepository) : super(SearchInitial());

  // Method to search with a query
  void search(String query) async {
    emit(SearchLoading());
    final result = await searchRepository.searchFiles(query);
    result.fold(
          (failure) => emit(SearchError(failure.errMessage)),
          (searchResults) => emit(SearchSucsess(searchResults)),
    );
  }

  // Method to set initial search results
  void setSearchResults(List<SearchResult> results) {
    emit(SearchSucsess(results));
  }

  Future<void>searchQueries()async{
    emit(SearchLoading());
    final result = await searchRepository.queries();
    result.fold(
        (failure)=> emit(SearchError(failure.errMessage)),
        (queries)=> emit(QueriesSuccess(queries ))

    );
  }



}
