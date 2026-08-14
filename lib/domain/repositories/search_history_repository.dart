abstract class SearchHistoryRepository {
  Future<List<String>> getRecentSearches();
  Future<void> addSearch(String username);
  Future<void> removeSearch(String username);
  Future<void> clearAllSearches();
}
