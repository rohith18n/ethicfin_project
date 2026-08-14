import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:ethicfin_project/domain/usecases/search_history_usecases.dart';
import 'package:ethicfin_project/presentation/blocs/recent_searches/recent_searches_bloc.dart';
import 'package:ethicfin_project/presentation/blocs/recent_searches/recent_searches_event.dart';
import 'package:ethicfin_project/presentation/blocs/recent_searches/recent_searches_state.dart';

class MockGetRecentSearchesUseCase extends Mock implements GetRecentSearchesUseCase {}
class MockAddRecentSearchUseCase extends Mock implements AddRecentSearchUseCase {}
class MockRemoveRecentSearchUseCase extends Mock implements RemoveRecentSearchUseCase {}
class MockClearRecentSearchesUseCase extends Mock implements ClearRecentSearchesUseCase {}

void main() {
  late MockGetRecentSearchesUseCase mockGetUseCase;
  late MockAddRecentSearchUseCase mockAddUseCase;
  late MockRemoveRecentSearchUseCase mockRemoveUseCase;
  late MockClearRecentSearchesUseCase mockClearUseCase;
  late RecentSearchesBloc bloc;

  setUp(() {
    mockGetUseCase = MockGetRecentSearchesUseCase();
    mockAddUseCase = MockAddRecentSearchUseCase();
    mockRemoveUseCase = MockRemoveRecentSearchUseCase();
    mockClearUseCase = MockClearRecentSearchesUseCase();

    bloc = RecentSearchesBloc(
      getRecentSearchesUseCase: mockGetUseCase,
      addRecentSearchUseCase: mockAddUseCase,
      removeRecentSearchUseCase: mockRemoveUseCase,
      clearRecentSearchesUseCase: mockClearUseCase,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('RecentSearchesBloc', () {
    test('initial state has empty searches', () {
      expect(bloc.state, const RecentSearchesState());
    });

    blocTest<RecentSearchesBloc, RecentSearchesState>(
      'loads recent searches successfully',
      build: () {
        when(() => mockGetUseCase()).thenAnswer((_) async => ['flutter', 'torvalds']);
        return bloc;
      },
      act: (bloc) => bloc.add(const LoadRecentSearches()),
      expect: () => [
        const RecentSearchesState(isLoading: true),
        const RecentSearchesState(searches: ['flutter', 'torvalds'], isLoading: false),
      ],
    );

    blocTest<RecentSearchesBloc, RecentSearchesState>(
      'adds search item and refreshes list',
      build: () {
        when(() => mockAddUseCase('google')).thenAnswer((_) async {});
        when(() => mockGetUseCase()).thenAnswer((_) async => ['google', 'flutter']);
        return bloc;
      },
      act: (bloc) => bloc.add(const AddSearchHistory('google')),
      expect: () => [
        const RecentSearchesState(searches: ['google', 'flutter'], isLoading: false),
      ],
    );

    blocTest<RecentSearchesBloc, RecentSearchesState>(
      'clears all search history',
      build: () {
        when(() => mockClearUseCase()).thenAnswer((_) async {});
        return bloc;
      },
      act: (bloc) => bloc.add(const ClearAllSearchHistory()),
      expect: () => [
        const RecentSearchesState(searches: [], isLoading: false),
      ],
    );
  });
}
