import '../entities/github_user.dart';
import '../entities/github_repo.dart';

abstract class GithubRepository {
  Future<GithubUser> getUser(String username);
  Future<List<GithubRepo>> getUserRepos(String username, {int perPage = 100, int page = 1});
}
