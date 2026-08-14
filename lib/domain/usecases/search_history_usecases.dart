import '../repositories/search_history_repository.dart';

class GetRecentSearchesUseCase {
  final SearchHistoryRepository repository;
  GetRecentSearchesUseCase(this.repository);

  Future<List<String>> call() async {
    return await repository.getRecentSearches();
  }
}

class AddRecentSearchUseCase {
  final SearchHistoryRepository repository;
  AddRecentSearchUseCase(this.repository);

  Future<void> call(String username) async {
    await repository.addSearch(username);
  }
}

class RemoveRecentSearchUseCase {
  final SearchHistoryRepository repository;
  RemoveRecentSearchUseCase(this.repository);

  Future<void> call(String username) async {
    await repository.removeSearch(username);
  }
}

class ClearRecentSearchesUseCase {
  final SearchHistoryRepository repository;
  ClearRecentSearchesUseCase(this.repository);

  Future<void> call() async {
    await repository.clearAllSearches();
  }
}
