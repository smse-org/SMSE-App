import 'package:equatable/equatable.dart';
import 'package:smse/features/search/data/model/search_query.dart';
import 'package:smse/features/search/data/model/search_results.dart';

abstract class SearchState extends Equatable {
  const SearchState();
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}
class SearchSucsess extends SearchState {
  final List<SearchResult> searchResults;
  const SearchSucsess(this.searchResults);
  @override
  List<Object?> get props => [searchResults];
}

class SearchSuggestionsLoaded extends SearchState{
  final List<String> suggestions;

  const SearchSuggestionsLoaded(this.suggestions);
  @override
  List<Object?> get props => [suggestions];
}

class QueriesSuccess extends SearchState{
  final List<SearchQuery> queries;
  const QueriesSuccess(this.queries);
  @override
  List<Object?> get props => [queries];
}
class SearchError extends SearchState {
  final String message;
  const SearchError(this.message);
  @override
  List<Object?> get props => [message];
}
class DeleteQuerySuccess extends SearchState {
  final String message;
  const DeleteQuerySuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ModalityChanged extends SearchState {
  final List<String> modalities;

  const ModalityChanged(this.modalities);

  @override
  List<Object?> get props => [modalities];
}