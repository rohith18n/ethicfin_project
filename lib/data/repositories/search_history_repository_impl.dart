import '../../domain/repositories/search_history_repository.dart';
import '../datasources/search_history_local_datasource.dart';

class SearchHistoryRepositoryImpl implements SearchHistoryRepository {
  final SearchHistoryLocalDataSource localDataSource;

  SearchHistoryRepositoryImpl({required this.localDataSource});

  @override
  Future<List<String>> getRecentSearches() async {
    return await localDataSource.getRecentSearches();
  }

  @override
  Future<void> addSearch(String username) async {
    await localDataSource.addSearch(username);
  }

  @override
  Future<void> removeSearch(String username) async {
    await localDataSource.removeSearch(username);
  }

  @override
  Future<void> clearAllSearches() async {
    await localDataSource.clearAllSearches();
  }
}
