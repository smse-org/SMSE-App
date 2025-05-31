part of 'search_cubit.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object> get props => [];
}

class SearchInitial extends SearchState {}

class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<SearchQuery> queries;
  final bool hasMore;

  const SearchLoaded({
    required this.queries,
    required this.hasMore,
  });

  @override
  List<Object> get props => [queries, hasMore];
}

class SearchError extends SearchState {
  final String message;

  const SearchError({required this.message});

  @override
  List<Object> get props => [message];
} 