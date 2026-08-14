import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/language_colors.dart';
import '../../../../domain/entities/github_repo.dart';
import 'repo_detail_modal.dart';

class RepoCard extends StatelessWidget {
  final GithubRepo repo;

  const RepoCard({super.key, required this.repo});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langColor = LanguageColors.getLanguageColor(repo.language);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => RepoDetailModal.show(context, repo),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Repo Name & Fork/Archived indicator
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    repo.isFork ? Icons.call_split_rounded : Icons.bookmark_outline_rounded,
                    color: AppColors.githubBlue,
                    size: 18,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      repo.name,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.githubBlue,
                            fontSize: 16,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (repo.isArchived) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.githubOrange.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Archived',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: AppColors.githubOrange,
                        ),
                      ),
                    ),
                  ],
                ],
              ),

              // Description
              if (repo.description != null && repo.description!.trim().isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  repo.description!.trim(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        fontSize: 13,
                        height: 1.35,
                      ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],

              // Topics Chips (first 3)
              if (repo.topics.isNotEmpty) ...[
                const SizedBox(height: 10),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: repo.topics.take(3).map((topic) {
                    return Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.githubBlue.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '#$topic',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.githubBlue,
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],

              const SizedBox(height: 12),

              // Footer: Language, Stars, Forks, Updated Time
              Row(
                children: [
                  // Language dot & name
                  if (repo.language != null) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 9,
                          height: 9,
                          decoration: BoxDecoration(
                            color: langColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          repo.language!,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                  ],

                  // Stars
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.star_rounded, size: 15, color: AppColors.githubYellow),
                      const SizedBox(width: 4),
                      Text(
                        DateFormatter.formatNumber(repo.stargazersCount),
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 14),

                  // Forks
                  if (repo.forksCount > 0) ...[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.fork_right_rounded,
                          size: 15,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          DateFormatter.formatNumber(repo.forksCount),
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),
                  ],

                  const Spacer(),

                  // Last Updated
                  if (repo.updatedAt != null)
                    Text(
                      'Updated ${DateFormatter.formatRelativeTime(repo.updatedAt)}',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
