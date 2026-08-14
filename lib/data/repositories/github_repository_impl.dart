import '../../domain/entities/github_user.dart';
import '../../domain/entities/github_repo.dart';
import '../../domain/repositories/github_repository.dart';
import '../datasources/github_remote_datasource.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remoteDataSource;

  GithubRepositoryImpl({required this.remoteDataSource});

  @override
  Future<GithubUser> getUser(String username) async {
    return await remoteDataSource.getUser(username);
  }

  @override
  Future<List<GithubRepo>> getUserRepos(String username, {int perPage = 100, int page = 1}) async {
    return await remoteDataSource.getUserRepos(username, perPage: perPage, page: page);
  }
}
