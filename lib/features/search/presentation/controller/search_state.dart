import 'package:equatable/equatable.dart';
import 'package:smse/features/search/data/model/search_results.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSucsess extends SearchState {
  final List<SearchResult> searchResults;
  const SearchSucsess(this.searchResults);
  @override
  List<Object> get props => [searchResults];
}
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object> get props => [message];
}