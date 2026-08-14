class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.github.com';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  // Optional GitHub Personal Access Token for 5,000 req/hr (instead of 60 req/hr unauthenticated)
  // Can be passed via: flutter run --dart-define=GITHUB_TOKEN=your_token_here
  static const String githubToken = String.fromEnvironment('GITHUB_TOKEN', defaultValue: '');

  static String userUrl(String username) => '$baseUrl/users/$username';
  static String userReposUrl(String username, {int perPage = 100, int page = 1}) =>
      '$baseUrl/users/$username/repos?per_page=$perPage&page=$page&sort=updated';

  static Map<String, String> get defaultHeaders => {
        'Accept': 'application/vnd.github.v3+json',
        'User-Agent': 'GitHub-Profile-Explorer-Flutter',
        if (githubToken.isNotEmpty) 'Authorization': 'Bearer $githubToken',
      };
}
