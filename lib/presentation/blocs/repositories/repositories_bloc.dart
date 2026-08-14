import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/get_user_repos_usecase.dart';
import 'repositories_event.dart';
import 'repositories_state.dart';

class RepositoriesBloc extends Bloc<RepositoriesEvent, RepositoriesState> {
  final GetUserReposUseCase getUserReposUseCase;

  RepositoriesBloc({required this.getUserReposUseCase})
      : super(const RepositoriesInitial()) {
    on<FetchRepositoriesRequested>(_onFetchRepositoriesRequested);
    on<SortRepositoriesChanged>(_onSortRepositoriesChanged);
    on<LanguageFilterChanged>(_onLanguageFilterChanged);
    on<SearchQueryFilterChanged>(_onSearchQueryFilterChanged);
    on<ClearRepoFiltersRequested>(_onClearRepoFiltersRequested);
  }

  Future<void> _onFetchRepositoriesRequested(
    FetchRepositoriesRequested event,
    Emitter<RepositoriesState> emit,
  ) async {
    final clean = event.username.trim();
    if (clean.isEmpty) return;

    emit(RepositoriesLoading(clean));

    try {
      final repos = await getUserReposUseCase(clean);
      emit(RepositoriesLoaded(
        username: clean,
        allRepos: repos,
      ));
    } on UserNotFoundException catch (e) {
      emit(RepositoriesError(
        failure: UserNotFoundFailure(e.message),
        username: clean,
      ));
    } on RateLimitException catch (e) {
      emit(RepositoriesError(
        failure: RateLimitFailure(e.message, e.resetTime),
        username: clean,
      ));
    } on NetworkException catch (e) {
      emit(RepositoriesError(
        failure: NetworkFailure(e.message),
        username: clean,
      ));
    } on TimeoutException catch (e) {
      emit(RepositoriesError(
        failure: TimeoutFailure(e.message),
        username: clean,
      ));
    } on ServerException catch (e) {
      emit(RepositoriesError(
        failure: ServerFailure(e.message, e.statusCode),
        username: clean,
      ));
    } catch (e) {
      emit(RepositoriesError(
        failure: UnknownFailure(e.toString()),
        username: clean,
      ));
    }
  }

  void _onSortRepositoriesChanged(
    SortRepositoriesChanged event,
    Emitter<RepositoriesState> emit,
  ) {
    if (state is RepositoriesLoaded) {
      final current = state as RepositoriesLoaded;
      emit(current.copyWith(selectedSort: event.sortOption));
    }
  }

  void _onLanguageFilterChanged(
    LanguageFilterChanged event,
    Emitter<RepositoriesState> emit,
  ) {
    if (state is RepositoriesLoaded) {
      final current = state as RepositoriesLoaded;
      emit(current.copyWith(selectedLanguage: () => event.language));
    }
  }

  void _onSearchQueryFilterChanged(
    SearchQueryFilterChanged event,
    Emitter<RepositoriesState> emit,
  ) {
    if (state is RepositoriesLoaded) {
      final current = state as RepositoriesLoaded;
      emit(current.copyWith(searchFilter: event.query));
    }
  }

  void _onClearRepoFiltersRequested(
    ClearRepoFiltersRequested event,
    Emitter<RepositoriesState> emit,
  ) {
    if (state is RepositoriesLoaded) {
      final current = state as RepositoriesLoaded;
      emit(current.copyWith(
        searchFilter: '',
        selectedLanguage: () => null,
        selectedSort: RepoSortOption.stars,
      ));
    }
  }
}
