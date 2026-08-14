import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/search_history_usecases.dart';
import 'recent_searches_event.dart';
import 'recent_searches_state.dart';

class RecentSearchesBloc extends Bloc<RecentSearchesEvent, RecentSearchesState> {
  final GetRecentSearchesUseCase getRecentSearchesUseCase;
  final AddRecentSearchUseCase addRecentSearchUseCase;
  final RemoveRecentSearchUseCase removeRecentSearchUseCase;
  final ClearRecentSearchesUseCase clearRecentSearchesUseCase;

  RecentSearchesBloc({
    required this.getRecentSearchesUseCase,
    required this.addRecentSearchUseCase,
    required this.removeRecentSearchUseCase,
    required this.clearRecentSearchesUseCase,
  }) : super(const RecentSearchesState()) {
    on<LoadRecentSearches>(_onLoadRecentSearches);
    on<AddSearchHistory>(_onAddSearchHistory);
    on<RemoveSearchHistory>(_onRemoveSearchHistory);
    on<ClearAllSearchHistory>(_onClearAllSearchHistory);
  }

  Future<void> _onLoadRecentSearches(
    LoadRecentSearches event,
    Emitter<RecentSearchesState> emit,
  ) async {
    emit(state.copyWith(isLoading: true));
    try {
      final searches = await getRecentSearchesUseCase();
      emit(RecentSearchesState(searches: searches, isLoading: false));
    } catch (_) {
      emit(state.copyWith(isLoading: false));
    }
  }

  Future<void> _onAddSearchHistory(
    AddSearchHistory event,
    Emitter<RecentSearchesState> emit,
  ) async {
    final clean = event.username.trim();
    if (clean.isEmpty) return;

    try {
      await addRecentSearchUseCase(clean);
      final searches = await getRecentSearchesUseCase();
      emit(RecentSearchesState(searches: searches, isLoading: false));
    } catch (_) {}
  }

  Future<void> _onRemoveSearchHistory(
    RemoveSearchHistory event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      await removeRecentSearchUseCase(event.username);
      final searches = await getRecentSearchesUseCase();
      emit(RecentSearchesState(searches: searches, isLoading: false));
    } catch (_) {}
  }

  Future<void> _onClearAllSearchHistory(
    ClearAllSearchHistory event,
    Emitter<RecentSearchesState> emit,
  ) async {
    try {
      await clearRecentSearchesUseCase();
      emit(const RecentSearchesState(searches: [], isLoading: false));
    } catch (_) {}
  }
}
