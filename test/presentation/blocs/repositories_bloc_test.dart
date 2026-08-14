import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ethicfin_project/core/errors/exceptions.dart';
import 'package:ethicfin_project/core/errors/failures.dart';
import 'package:ethicfin_project/domain/entities/github_repo.dart';
import 'package:ethicfin_project/domain/usecases/get_user_repos_usecase.dart';
import 'package:ethicfin_project/presentation/blocs/repositories/repositories_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/repositories/repositories_event.dart';
import 'package:ethicfin_project/presentation/blocs/repositories/repositories_state.dart';

class MockGetUserReposUseCase extends Mock implements GetUserReposUseCase {}

void main() {
  late MockGetUserReposUseCase mockGetUserReposUseCase;
  late RepositoriesBloc repositoriesBloc;

  final tRepos = [
    GithubRepo(
      id: 1,
      name: 'flutter',
      fullName: 'flutter/flutter',
      description: 'Flutter SDK',
      htmlUrl: 'https://github.com/flutter/flutter',
      stargazersCount: 160000,
      forksCount: 26000,
      openIssuesCount: 5000,
      watchersCount: 160000,
      language: 'Dart',
      updatedAt: DateTime.parse('2024-05-01T10:00:00Z'),
    ),
    GithubRepo(
      id: 2,
      name: 'engine',
      fullName: 'flutter/engine',
      description: 'Engine for Flutter',
      htmlUrl: 'https://github.com/flutter/engine',
      stargazersCount: 8000,
      forksCount: 3000,
      openIssuesCount: 100,
      watchersCount: 8000,
      language: 'C++',
      updatedAt: DateTime.parse('2024-05-02T10:00:00Z'),
    ),
  ];

  setUp(() {
    mockGetUserReposUseCase = MockGetUserReposUseCase();
    repositoriesBloc = RepositoriesBloc(getUserReposUseCase: mockGetUserReposUseCase);
  });

  tearDown(() {
    repositoriesBloc.close();
  });

  group('RepositoriesBloc', () {
    test('initial state is RepositoriesInitial', () {
      expect(repositoriesBloc.state, const RepositoriesInitial());
    });

    blocTest<RepositoriesBloc, RepositoriesState>(
      'emits [RepositoriesLoading, RepositoriesLoaded] on successful fetch',
      build: () {
        when(() => mockGetUserReposUseCase('flutter', perPage: 100, page: 1))
            .thenAnswer((_) async => tRepos);
        return repositoriesBloc;
      },
      act: (bloc) => bloc.add(const FetchRepositoriesRequested('flutter')),
      expect: () => [
        const RepositoriesLoading('flutter'),
        RepositoriesLoaded(username: 'flutter', allRepos: tRepos),
      ],
    );

    blocTest<RepositoriesBloc, RepositoriesState>(
      'emits [RepositoriesLoading, RepositoriesError] when fetch fails with UserNotFoundException',
      build: () {
        when(() => mockGetUserReposUseCase('invalid_user', perPage: 100, page: 1))
            .thenThrow(const UserNotFoundException('User not found.'));
        return repositoriesBloc;
      },
      act: (bloc) => bloc.add(const FetchRepositoriesRequested('invalid_user')),
      expect: () => [
        const RepositoriesLoading('invalid_user'),
        const RepositoriesError(
          failure: UserNotFoundFailure('User not found.'),
          username: 'invalid_user',
        ),
      ],
    );

    blocTest<RepositoriesBloc, RepositoriesState>(
      'updates sort option when SortRepositoriesChanged is added',
      build: () => repositoriesBloc,
      seed: () => RepositoriesLoaded(username: 'flutter', allRepos: tRepos),
      act: (bloc) => bloc.add(const SortRepositoriesChanged(RepoSortOption.updated)),
      expect: () => [
        RepositoriesLoaded(
          username: 'flutter',
          allRepos: tRepos,
          selectedSort: RepoSortOption.updated,
        ),
      ],
    );

    blocTest<RepositoriesBloc, RepositoriesState>(
      'updates language filter when LanguageFilterChanged is added',
      build: () => repositoriesBloc,
      seed: () => RepositoriesLoaded(username: 'flutter', allRepos: tRepos),
      act: (bloc) => bloc.add(const LanguageFilterChanged('Dart')),
      expect: () => [
        RepositoriesLoaded(
          username: 'flutter',
          allRepos: tRepos,
          selectedLanguage: 'Dart',
        ),
      ],
    );
  });
}
