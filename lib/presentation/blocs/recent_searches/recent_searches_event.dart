import 'package:equatable/equatable.dart';

abstract class RecentSearchesEvent extends Equatable {
  const RecentSearchesEvent();

  @override
  List<Object?> get props => [];
}

class LoadRecentSearches extends RecentSearchesEvent {
  const LoadRecentSearches();
}

class AddSearchHistory extends RecentSearchesEvent {
  final String username;
  const AddSearchHistory(this.username);

  @override
  List<Object?> get props => [username];
}

class RemoveSearchHistory extends RecentSearchesEvent {
  final String username;
  const RemoveSearchHistory(this.username);

  @override
  List<Object?> get props => [username];
}

class ClearAllSearchHistory extends RecentSearchesEvent {
  const ClearAllSearchHistory();
}
