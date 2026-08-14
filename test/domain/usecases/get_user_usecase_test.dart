import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ethicfin_project/domain/entities/github_user.dart';
import 'package:ethicfin_project/domain/repositories/github_repository.dart';
import 'package:ethicfin_project/domain/usecases/get_user_usecase.dart';

class MockGithubRepository extends Mock implements GithubRepository {}

void main() {
  late MockGithubRepository mockRepository;
  late GetUserUseCase useCase;

  const tUser = GithubUser(
    id: 1,
    login: 'flutter',
    name: 'Flutter Devs',
    avatarUrl: 'https://avatars.githubusercontent.com/u/14101776',
    htmlUrl: 'https://github.com/flutter',
    publicRepos: 45,
    publicGists: 0,
    followers: 120000,
    following: 0,
  );

  setUp(() {
    mockRepository = MockGithubRepository();
    useCase = GetUserUseCase(mockRepository);
  });

  test('should call repository.getUser and return GithubUser', () async {
    when(() => mockRepository.getUser('flutter'))
        .thenAnswer((_) async => tUser);

    final result = await useCase('flutter');

    expect(result, tUser);
    verify(() => mockRepository.getUser('flutter')).called(1);
    verifyNoMoreInteractions(mockRepository);
  });
}
