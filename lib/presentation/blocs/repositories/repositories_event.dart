import 'package:equatable/equatable.dart';

enum RepoSortOption {
  stars('Most Stars', '⭐'),
  updated('Recently Updated', '🕒'),
  forks('Most Forks', '🍴'),
  name('Name (A-Z)', '🔤');

  final String label;
  final String icon;
  const RepoSortOption(this.label, this.icon);
}

abstract class RepositoriesEvent extends Equatable {
  const RepositoriesEvent();

  @override
  List<Object?> get props => [];
}

class FetchRepositoriesRequested extends RepositoriesEvent {
  final String username;

  const FetchRepositoriesRequested(this.username);

  @override
  List<Object?> get props => [username];
}

class SortRepositoriesChanged extends RepositoriesEvent {
  final RepoSortOption sortOption;

  const SortRepositoriesChanged(this.sortOption);

  @override
  List<Object?> get props => [sortOption];
}

class LanguageFilterChanged extends RepositoriesEvent {
  final String? language;

  const LanguageFilterChanged(this.language);

  @override
  List<Object?> get props => [language];
}

class SearchQueryFilterChanged extends RepositoriesEvent {
  final String query;

  const SearchQueryFilterChanged(this.query);

  @override
  List<Object?> get props => [query];
}

class ClearRepoFiltersRequested extends RepositoriesEvent {
  const ClearRepoFiltersRequested();
}
