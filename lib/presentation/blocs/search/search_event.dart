import 'package:equatable/equatable.dart';

abstract class SearchEvent extends Equatable {
  const SearchEvent();

  @override
  List<Object?> get props => [];
}

class SearchUserRequested extends SearchEvent {
  final String username;

  const SearchUserRequested(this.username);

  @override
  List<Object?> get props => [username];
}

class ClearSearchRequested extends SearchEvent {
  const ClearSearchRequested();
}

class RetrySearchRequested extends SearchEvent {
  const RetrySearchRequested();
}
