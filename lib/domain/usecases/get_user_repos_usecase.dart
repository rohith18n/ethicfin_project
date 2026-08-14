import '../entities/github_repo.dart';
import '../repositories/github_repository.dart';

class GetUserReposUseCase {
  final GithubRepository repository;

  GetUserReposUseCase(this.repository);

  Future<List<GithubRepo>> call(String username, {int perPage = 100, int page = 1}) async {
    return await repository.getUserRepos(username, perPage: perPage, page: page);
  }
}
