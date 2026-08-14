class ApiConstants {
  ApiConstants._();

  static const String baseUrl = 'https://api.github.com';
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 10);

  static String userUrl(String username) => '$baseUrl/users/$username';
  static String userReposUrl(String username, {int perPage = 100, int page = 1}) =>
      '$baseUrl/users/$username/repos?per_page=$perPage&page=$page&sort=updated';

  static const Map<String, String> defaultHeaders = {
    'Accept': 'application/vnd.github.v3+json',
    'User-Agent': 'GitHub-Profile-Explorer-Flutter',
  };
}
