import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../blocs/repositories/repositories_bloc.dart';
import '../../blocs/repositories/repositories_event.dart';
import '../../blocs/repositories/repositories_state.dart';
import '../../widgets/custom_error_widget.dart';
import 'widgets/repo_card.dart';
import 'widgets/repo_shimmer_list.dart';
import 'widgets/repo_sort_filter_bar.dart';

class RepositoriesScreen extends StatefulWidget {
  final String username;

  const RepositoriesScreen({
    super.key,
    required this.username,
  });

  @override
  State<RepositoriesScreen> createState() => _RepositoriesScreenState();
}

class _RepositoriesScreenState extends State<RepositoriesScreen> {
  @override
  void initState() {
    super.initState();
    final repoBloc = context.read<RepositoriesBloc>();
    final state = repoBloc.state;
    if (state is! RepositoriesLoaded || state.username != widget.username) {
      repoBloc.add(FetchRepositoriesRequested(widget.username));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: BlocBuilder<RepositoriesBloc, RepositoriesState>(
          builder: (context, state) {
            final repoCount = state is RepositoriesLoaded ? state.filteredAndSortedRepos.length : 0;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.username,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                if (state is RepositoriesLoaded)
                  Text(
                    '$repoCount ${repoCount == 1 ? "repository" : "repositories"}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    ),
                  ),
              ],
            );
          },
        ),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            context.read<RepositoriesBloc>().add(FetchRepositoriesRequested(widget.username));
          },
          child: BlocBuilder<RepositoriesBloc, RepositoriesState>(
            builder: (context, state) {
              if (state is RepositoriesLoading) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                  child: RepoShimmerList(),
                );
              }

              if (state is RepositoriesError) {
                return Center(
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: CustomErrorWidget(
                      failure: state.failure,
                      message: state.failure.message,
                      onRetry: () => context
                          .read<RepositoriesBloc>()
                          .add(FetchRepositoriesRequested(widget.username)),
                    ),
                  ),
                );
              }

              if (state is RepositoriesLoaded) {
                final repos = state.filteredAndSortedRepos;

                return CustomScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  slivers: [
                    // Filter & Sort Header
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                        child: RepoSortFilterBar(
                          availableLanguages: state.availableLanguages,
                          selectedLanguage: state.selectedLanguage,
                          selectedSort: state.selectedSort,
                          searchFilter: state.searchFilter,
                          onSelectLanguage: (lang) => context
                              .read<RepositoriesBloc>()
                              .add(LanguageFilterChanged(lang)),
                          onSelectSort: (sort) => context
                              .read<RepositoriesBloc>()
                              .add(SortRepositoriesChanged(sort)),
                          onSearchChanged: (query) => context
                              .read<RepositoriesBloc>()
                              .add(SearchQueryFilterChanged(query)),
                          onClearAll: () => context
                              .read<RepositoriesBloc>()
                              .add(const ClearRepoFiltersRequested()),
                        ),
                      ),
                    ),

                    // Repos List or Empty State
                    if (repos.isEmpty)
                      SliverFillRemaining(
                        hasScrollBody: false,
                        child: _buildEmptyState(context, isDark, state),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: RepoCard(repo: repos[index]),
                              );
                            },
                            childCount: repos.length,
                          ),
                        ),
                      ),
                  ],
                );
              }

              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, bool isDark, RepositoriesLoaded state) {
    final hasFilters = state.searchFilter.isNotEmpty || state.selectedLanguage != null;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: (isDark ? AppColors.darkCard : AppColors.lightCardHover),
                shape: BoxShape.circle,
              ),
              child: Icon(
                hasFilters ? Icons.search_off_rounded : Icons.folder_open_rounded,
                size: 32,
                color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              hasFilters ? 'No Matching Repositories' : 'No Public Repositories',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              hasFilters
                  ? 'Try adjusting your search query or language filter.'
                  : '@${widget.username} does not have any public repositories yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              ),
            ),
            if (hasFilters) ...[
              const SizedBox(height: 16),
              TextButton.icon(
                onPressed: () => context
                    .read<RepositoriesBloc>()
                    .add(const ClearRepoFiltersRequested()),
                icon: const Icon(Icons.clear_all_rounded, size: 16),
                label: const Text('Reset Filters'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
