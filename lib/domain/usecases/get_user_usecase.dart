import '../entities/github_user.dart';
import '../repositories/github_repository.dart';

class GetUserUseCase {
  final GithubRepository repository;

  GetUserUseCase(this.repository);

  Future<GithubUser> call(String username) async {
    return await repository.getUser(username);
  }
}
