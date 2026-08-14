import 'package:shared_preferences/shared_preferences.dart';

abstract class SearchHistoryLocalDataSource {
  Future<List<String>> getRecentSearches();
  Future<void> addSearch(String username);
  Future<void> removeSearch(String username);
  Future<void> clearAllSearches();
}

class SearchHistoryLocalDataSourceImpl implements SearchHistoryLocalDataSource {
  static const String _key = 'recent_github_searches';
  static const int _maxItems = 10;

  final SharedPreferences sharedPreferences;

  SearchHistoryLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<String>> getRecentSearches() async {
    return sharedPreferences.getStringList(_key) ?? [];
  }

  @override
  Future<void> addSearch(String username) async {
    final clean = username.trim();
    if (clean.isEmpty) return;

    final current = (sharedPreferences.getStringList(_key) ?? []).toList();
    // Remove if already exists (case-insensitive deduplication)
    current.removeWhere((item) => item.toLowerCase() == clean.toLowerCase());
    // Insert at front (most recent)
    current.insert(0, clean);
    // Keep max items (bonus asked for last 5, we support up to 10 for great UX)
    if (current.length > _maxItems) {
      current.removeRange(_maxItems, current.length);
    }
    await sharedPreferences.setStringList(_key, current);
  }

  @override
  Future<void> removeSearch(String username) async {
    final clean = username.trim();
    final current = (sharedPreferences.getStringList(_key) ?? []).toList();
    current.removeWhere((item) => item.toLowerCase() == clean.toLowerCase());
    await sharedPreferences.setStringList(_key, current);
  }

  @override
  Future<void> clearAllSearches() async {
    await sharedPreferences.remove(_key);
  }
}
