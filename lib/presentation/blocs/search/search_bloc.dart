import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/errors/exceptions.dart';
import '../../../core/errors/failures.dart';
import '../../../domain/usecases/get_user_usecase.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchBloc extends Bloc<SearchEvent, SearchState> {
  final GetUserUseCase getUserUseCase;
  String _lastQuery = '';

  SearchBloc({required this.getUserUseCase}) : super(const SearchInitial()) {
    on<SearchUserRequested>(_onSearchUserRequested);
    on<ClearSearchRequested>(_onClearSearchRequested);
    on<RetrySearchRequested>(_onRetrySearchRequested);
  }

  String get lastQuery => _lastQuery;

  Future<void> _onSearchUserRequested(
    SearchUserRequested event,
    Emitter<SearchState> emit,
  ) async {
    final clean = event.username.trim();
    if (clean.isEmpty) return;

    _lastQuery = clean;
    emit(SearchLoading(clean));

    try {
      final user = await getUserUseCase(clean);
      emit(SearchLoaded(user));
    } on UserNotFoundException catch (e) {
      emit(SearchError(
        failure: UserNotFoundFailure(e.message),
        query: clean,
      ));
    } on RateLimitException catch (e) {
      emit(SearchError(
        failure: RateLimitFailure(e.message, e.resetTime),
        query: clean,
      ));
    } on NetworkException catch (e) {
      emit(SearchError(
        failure: NetworkFailure(e.message),
        query: clean,
      ));
    } on TimeoutException catch (e) {
      emit(SearchError(
        failure: TimeoutFailure(e.message),
        query: clean,
      ));
    } on ServerException catch (e) {
      emit(SearchError(
        failure: ServerFailure(e.message, e.statusCode),
        query: clean,
      ));
    } catch (e) {
      emit(SearchError(
        failure: UnknownFailure(e.toString()),
        query: clean,
      ));
    }
  }

  void _onClearSearchRequested(
    ClearSearchRequested event,
    Emitter<SearchState> emit,
  ) {
    _lastQuery = '';
    emit(const SearchInitial());
  }

  void _onRetrySearchRequested(
    RetrySearchRequested event,
    Emitter<SearchState> emit,
  ) {
    if (_lastQuery.isNotEmpty) {
      add(SearchUserRequested(_lastQuery));
    }
  }
}
