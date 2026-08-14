import '../../core/constants/api_constants.dart';
import '../../core/network/api_client.dart';
import '../models/github_user_model.dart';
import '../models/github_repo_model.dart';

abstract class GithubRemoteDataSource {
  Future<GithubUserModel> getUser(String username);
  Future<List<GithubRepoModel>> getUserRepos(String username, {int perPage = 100, int page = 1});
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final ApiClient apiClient;

  GithubRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<GithubUserModel> getUser(String username) async {
    final cleanUsername = username.trim();
    final data = await apiClient.get(ApiConstants.userUrl(cleanUsername));
    if (data is Map<String, dynamic>) {
      return GithubUserModel.fromJson(data);
    } else if (data is Map) {
      return GithubUserModel.fromJson(Map<String, dynamic>.from(data));
    }
    throw const FormatException('Invalid user response structure from GitHub');
  }

  @override
  Future<List<GithubRepoModel>> getUserRepos(String username, {int perPage = 100, int page = 1}) async {
    final cleanUsername = username.trim();
    final data = await apiClient.get(
      ApiConstants.userReposUrl(cleanUsername, perPage: perPage, page: page),
    );
    if (data is List) {
      return data
          .map((repoJson) => GithubRepoModel.fromJson(Map<String, dynamic>.from(repoJson as Map)))
          .toList();
    }
    return [];
  }
}
