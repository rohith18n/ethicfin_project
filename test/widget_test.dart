import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ethicfin_project/domain/entities/github_user.dart';
import 'package:ethicfin_project/domain/usecases/get_user_usecase.dart';
import 'package:ethicfin_project/domain/usecases/get_user_repos_usecase.dart';
import 'package:ethicfin_project/domain/usecases/search_history_usecases.dart';
import 'package:ethicfin_project/presentation/blocs/recent_searches/recent_searches_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/repositories/repositories_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/search/search_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/theme/theme_cubit.dart';
import 'package:ethicfin_project/presentation/screens/search/search_screen.dart';

class MockGetUserUseCase extends Mock implements GetUserUseCase {}
class MockGetUserReposUseCase extends Mock implements GetUserReposUseCase {}
class MockGetRecentSearchesUseCase extends Mock implements GetRecentSearchesUseCase {}
class MockAddRecentSearchUseCase extends Mock implements AddRecentSearchUseCase {}
class MockRemoveRecentSearchUseCase extends Mock implements RemoveRecentSearchUseCase {}
class MockClearRecentSearchesUseCase extends Mock implements ClearRecentSearchesUseCase {}

void main() {
  late MockGetUserUseCase mockGetUserUseCase;
  late MockGetUserReposUseCase mockGetUserReposUseCase;
  late MockGetRecentSearchesUseCase mockGetRecentSearchesUseCase;
  late MockAddRecentSearchUseCase mockAddRecentSearchUseCase;
  late MockRemoveRecentSearchUseCase mockRemoveRecentSearchUseCase;
  late MockClearRecentSearchesUseCase mockClearRecentSearchesUseCase;

  setUp(() {
    mockGetUserUseCase = MockGetUserUseCase();
    mockGetUserReposUseCase = MockGetUserReposUseCase();
    mockGetRecentSearchesUseCase = MockGetRecentSearchesUseCase();
    mockAddRecentSearchUseCase = MockAddRecentSearchUseCase();
    mockRemoveRecentSearchUseCase = MockRemoveRecentSearchUseCase();
    mockClearRecentSearchesUseCase = MockClearRecentSearchesUseCase();

    SharedPreferences.setMockInitialValues({});
    when(() => mockGetRecentSearchesUseCase())
        .thenAnswer((_) async => ['flutter', 'torvalds']);
  });

  Widget createTestWidget(SharedPreferences prefs) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<ThemeCubit>(
          create: (_) => ThemeCubit(sharedPreferences: prefs),
        ),
        BlocProvider<SearchBloc>(
          create: (_) => SearchBloc(getUserUseCase: mockGetUserUseCase),
        ),
        BlocProvider<RepositoriesBloc>(
          create: (_) => RepositoriesBloc(getUserReposUseCase: mockGetUserReposUseCase),
        ),
        BlocProvider<RecentSearchesBloc>(
          create: (_) => RecentSearchesBloc(
            getRecentSearchesUseCase: mockGetRecentSearchesUseCase,
            addRecentSearchUseCase: mockAddRecentSearchUseCase,
            removeRecentSearchUseCase: mockRemoveRecentSearchUseCase,
            clearRecentSearchesUseCase: mockClearRecentSearchesUseCase,
          ),
        ),
      ],
      child: const MaterialApp(
        home: SearchScreen(),
      ),
    );
  }

  testWidgets('SearchScreen renders search bar, suggestions, and recent searches with BLoC', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    await tester.pumpWidget(createTestWidget(prefs));
    await tester.pump(const Duration(milliseconds: 200));

    // Verify title and search bar
    expect(find.text('GitHub Explorer'), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(find.text('Explore GitHub Universe'), findsOneWidget);

    // Verify recent searches are displayed
    expect(find.text('Recent Searches'), findsOneWidget);
    expect(find.text('flutter'), findsWidgets);
    expect(find.text('torvalds'), findsWidgets);
  });

  testWidgets('Searching user displays profile card with BLoC', (WidgetTester tester) async {
    final prefs = await SharedPreferences.getInstance();

    const tUser = GithubUser(
      id: 1,
      login: 'flutter',
      name: 'Flutter Devs',
      avatarUrl: 'https://avatars.githubusercontent.com/u/14101776',
      htmlUrl: 'https://github.com/flutter',
      bio: 'Google\'s UI toolkit for crafting beautiful apps',
      publicRepos: 45,
      publicGists: 0,
      followers: 120000,
      following: 0,
    );

    when(() => mockGetUserUseCase('flutter'))
        .thenAnswer((_) async => tUser);
    when(() => mockAddRecentSearchUseCase('flutter'))
        .thenAnswer((_) async {});

    await tester.pumpWidget(createTestWidget(prefs));
    await tester.pump(const Duration(milliseconds: 200));

    // Enter search query
    await tester.enterText(find.byType(TextField), 'flutter');
    await tester.testTextInput.receiveAction(TextInputAction.search);

    // Pump to process event
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // Check user profile is displayed
    expect(find.text('Flutter Devs'), findsOneWidget);
    expect(find.text('@flutter'), findsOneWidget);
    expect(find.text('Google\'s UI toolkit for crafting beautiful apps'), findsOneWidget);
    expect(find.text('View Repositories (45)'), findsOneWidget);
  });
}
