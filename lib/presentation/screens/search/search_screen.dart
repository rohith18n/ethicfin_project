import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../blocs/recent_searches/recent_searches_bloc.dart';
import '../../blocs/recent_searches/recent_searches_event.dart';
import '../../blocs/recent_searches/recent_searches_state.dart';
import '../../blocs/repositories/repositories_bloc.dart';
import '../../blocs/repositories/repositories_event.dart';
import '../../blocs/search/search_bloc.dart';
import '../../blocs/search/search_event.dart';
import '../../blocs/search/search_state.dart';
import '../../blocs/theme/theme_cubit.dart';
import '../../blocs/theme/theme_state.dart';
import '../../widgets/custom_error_widget.dart';
import '../repositories/repositories_screen.dart';
import 'widgets/empty_search_state.dart';
import 'widgets/recent_searches_widget.dart';
import 'widgets/search_bar_widget.dart';
import 'widgets/user_profile_card.dart';
import 'widgets/user_profile_shimmer.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<RecentSearchesBloc>().add(const LoadRecentSearches());
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _performSearch(String username) {
    final clean = username.trim();
    if (clean.isEmpty) return;

    FocusScope.of(context).unfocus();

    if (_searchController.text != clean) {
      _searchController.text = clean;
    }

    context.read<SearchBloc>().add(SearchUserRequested(clean));
    context.read<RecentSearchesBloc>().add(AddSearchHistory(clean));
  }

  void _navigateToRepositories(String username) {
    context.read<RepositoriesBloc>().add(FetchRepositoriesRequested(username));

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RepositoriesScreen(username: username),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, themeState) {
        return Scaffold(
          appBar: AppBar(
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.githubBlue.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.hub_rounded,
                    color: AppColors.githubBlue,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 10),
                const Text('GitHub Explorer'),
              ],
            ),
            actions: [
              IconButton(
                icon: Icon(
                  themeState.isDarkMode ? Icons.light_mode_rounded : Icons.dark_mode_rounded,
                  size: 20,
                ),
                tooltip: themeState.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                onPressed: () => context.read<ThemeCubit>().toggleTheme(),
              ),
              const SizedBox(width: 8),
            ],
          ),
          body: SafeArea(
            child: BlocBuilder<SearchBloc, SearchState>(
              builder: (context, searchState) {
                final isLoading = searchState is SearchLoading;

                return RefreshIndicator(
                  onRefresh: () async {
                    final searchBloc = context.read<SearchBloc>();
                    if (searchBloc.lastQuery.isNotEmpty) {
                      searchBloc.add(SearchUserRequested(searchBloc.lastQuery));
                    }
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Search Input Field
                        SearchBarWidget(
                          controller: _searchController,
                          isLoading: isLoading,
                          onSubmitted: _performSearch,
                          onClear: () {
                            _searchController.clear();
                            context.read<SearchBloc>().add(const ClearSearchRequested());
                          },
                        ),
                        const SizedBox(height: 16),

                        // Search States Handling
                        if (searchState is SearchLoading) ...[
                          const SizedBox(height: 12),
                          const UserProfileShimmer(),
                        ] else if (searchState is SearchError) ...[
                          CustomErrorWidget(
                            failure: searchState.failure,
                            message: searchState.failure.message,
                            onRetry: () => _performSearch(searchState.query),
                          ),
                        ] else if (searchState is SearchLoaded) ...[
                          UserProfileCard(
                            user: searchState.user,
                            onViewRepos: () => _navigateToRepositories(searchState.user.login),
                          ),
                        ] else ...[
                          // Initial / Empty State
                          EmptySearchState(
                            onSelectSuggestion: _performSearch,
                          ),
                        ],

                        // Recent Searches Section
                        BlocBuilder<RecentSearchesBloc, RecentSearchesState>(
                          builder: (context, recentState) {
                            if (!recentState.hasSearches) return const SizedBox.shrink();

                            return RecentSearchesWidget(
                              recentSearches: recentState.searches,
                              onSelect: _performSearch,
                              onRemove: (user) => context
                                  .read<RecentSearchesBloc>()
                                  .add(RemoveSearchHistory(user)),
                              onClearAll: () => context
                                  .read<RecentSearchesBloc>()
                                  .add(const ClearAllSearchHistory()),
                            );
                          },
                        ),

                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
