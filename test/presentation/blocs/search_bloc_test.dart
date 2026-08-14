import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ethicfin_project/core/errors/exceptions.dart';
import 'package:ethicfin_project/core/errors/failures.dart';
import 'package:ethicfin_project/domain/entities/github_user.dart';
import 'package:ethicfin_project/domain/usecases/get_user_usecase.dart';
import 'package:ethicfin_project/presentation/blocs/search/search_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/search/search_event.dart';
import 'package:ethicfin_project/presentation/blocs/search/search_state.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}

void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late SearchBloc searchBloc;

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
    mockGetUserUseCase = MockGetUserUseCase();
    searchBloc = SearchBloc(getUserUseCase: mockGetUserUseCase);
  });

  tearDown(() {
    searchBloc.close();
  });

  group('SearchBloc', () {
    test('initial state is SearchInitial', () {
      expect(searchBloc.state, const SearchInitial());
    });

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchLoaded] when SearchUserRequested succeeds',
      build: () {
        when(() => mockGetUserUseCase('flutter'))
            .thenAnswer((_) async => tUser);
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchUserRequested('flutter')),
      expect: () => [
        const SearchLoading('flutter'),
        const SearchLoaded(tUser),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] with UserNotFoundFailure on 404',
      build: () {
        when(() => mockGetUserUseCase('unknown_dev'))
            .thenThrow(const UserNotFoundException('User not found on GitHub.'));
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchUserRequested('unknown_dev')),
      expect: () => [
        const SearchLoading('unknown_dev'),
        const SearchError(
          failure: UserNotFoundFailure('User not found on GitHub.'),
          query: 'unknown_dev',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchLoading, SearchError] with NetworkFailure on offline',
      build: () {
        when(() => mockGetUserUseCase('flutter'))
            .thenThrow(const NetworkException());
        return searchBloc;
      },
      act: (bloc) => bloc.add(const SearchUserRequested('flutter')),
      expect: () => [
        const SearchLoading('flutter'),
        const SearchError(
          failure: NetworkFailure('No internet connection. Please check your network and retry.'),
          query: 'flutter',
        ),
      ],
    );

    blocTest<SearchBloc, SearchState>(
      'emits [SearchInitial] when ClearSearchRequested is dispatched',
      build: () => searchBloc,
      act: (bloc) => bloc.add(const ClearSearchRequested()),
      expect: () => [const SearchInitial()],
    );
  });
}
