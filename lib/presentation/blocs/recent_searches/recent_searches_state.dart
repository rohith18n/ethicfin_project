import 'package:equatable/equatable.dart';

class RecentSearchesState extends Equatable {
  final List<String> searches;
  final bool isLoading;

  const RecentSearchesState({
    this.searches = const [],
    this.isLoading = false,
  });

  bool get hasSearches => searches.isNotEmpty;

  RecentSearchesState copyWith({
    List<String>? searches,
    bool? isLoading,
  }) {
    return RecentSearchesState(
      searches: searches ?? this.searches,
      isLoading: isLoading ?? this.isLoading,
    );
  }

  @override
  List<Object?> get props => [searches, isLoading];
}
