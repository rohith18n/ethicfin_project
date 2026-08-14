import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/github_user.dart';

abstract class SearchState extends Equatable {
  const SearchState();

  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {
  const SearchInitial();
}

class SearchLoading extends SearchState {
  final String query;
  const SearchLoading(this.query);

  @override
  List<Object?> get props => [query];
}

class SearchLoaded extends SearchState {
  final GithubUser user;

  const SearchLoaded(this.user);

  @override
  List<Object?> get props => [user];
}

class SearchError extends SearchState {
  final AppFailure failure;
  final String query;

  const SearchError({required this.failure, required this.query});

  @override
  List<Object?> get props => [failure, query];
}
