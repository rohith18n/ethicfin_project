import 'package:equatable/equatable.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/entities/github_repo.dart';
import 'repositories_event.dart';

abstract class RepositoriesState extends Equatable {
  const RepositoriesState();

  @override
  List<Object?> get props => [];
}

class RepositoriesInitial extends RepositoriesState {
  const RepositoriesInitial();
}

class RepositoriesLoading extends RepositoriesState {
  final String username;
  const RepositoriesLoading(this.username);

  @override
  List<Object?> get props => [username];
}

class RepositoriesLoaded extends RepositoriesState {
  final String username;
  final List<GithubRepo> allRepos;
  final RepoSortOption selectedSort;
  final String? selectedLanguage;
  final String searchFilter;

  const RepositoriesLoaded({
    required this.username,
    required this.allRepos,
    this.selectedSort = RepoSortOption.stars,
    this.selectedLanguage,
    this.searchFilter = '',
  });

  List<String> get availableLanguages {
    final set = <String>{};
    for (final repo in allRepos) {
      if (repo.language != null && repo.language!.trim().isNotEmpty) {
        set.add(repo.language!.trim());
      }
    }
    final list = set.toList()..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));
    return list;
  }

  List<GithubRepo> get filteredAndSortedRepos {
    List<GithubRepo> list = List.from(allRepos);

    // 1. Filter by search text
    if (searchFilter.trim().isNotEmpty) {
      final query = searchFilter.toLowerCase().trim();
      list = list.where((repo) {
        final matchesName = repo.name.toLowerCase().contains(query);
        final matchesDesc = (repo.description ?? '').toLowerCase().contains(query);
        final matchesLang = (repo.language ?? '').toLowerCase().contains(query);
        final matchesTopic = repo.topics.any((t) => t.toLowerCase().contains(query));
        return matchesName || matchesDesc || matchesLang || matchesTopic;
      }).toList();
    }

    // 2. Filter by language
    if (selectedLanguage != null && selectedLanguage!.isNotEmpty) {
      list = list.where((repo) => repo.language?.toLowerCase() == selectedLanguage!.toLowerCase()).toList();
    }

    // 3. Sort
    switch (selectedSort) {
      case RepoSortOption.stars:
        list.sort((a, b) => b.stargazersCount.compareTo(a.stargazersCount));
        break;
      case RepoSortOption.updated:
        list.sort((a, b) {
          final aDate = a.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          final bDate = b.updatedAt ?? DateTime.fromMillisecondsSinceEpoch(0);
          return bDate.compareTo(aDate);
        });
        break;
      case RepoSortOption.forks:
        list.sort((a, b) => b.forksCount.compareTo(a.forksCount));
        break;
      case RepoSortOption.name:
        list.sort((a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()));
        break;
    }

    return list;
  }

  RepositoriesLoaded copyWith({
    String? username,
    List<GithubRepo>? allRepos,
    RepoSortOption? selectedSort,
    String? Function()? selectedLanguage,
    String? searchFilter,
  }) {
    return RepositoriesLoaded(
      username: username ?? this.username,
      allRepos: allRepos ?? this.allRepos,
      selectedSort: selectedSort ?? this.selectedSort,
      selectedLanguage: selectedLanguage != null ? selectedLanguage() : this.selectedLanguage,
      searchFilter: searchFilter ?? this.searchFilter,
    );
  }

  @override
  List<Object?> get props => [
        username,
        allRepos,
        selectedSort,
        selectedLanguage,
        searchFilter,
      ];
}

class RepositoriesError extends RepositoriesState {
  final AppFailure failure;
  final String username;

  const RepositoriesError({required this.failure, required this.username});

  @override
  List<Object?> get props => [failure, username];
}
