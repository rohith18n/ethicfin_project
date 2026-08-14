import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/language_colors.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../domain/entities/github_repo.dart';

class RepoDetailModal extends StatelessWidget {
  final GithubRepo repo;

  const RepoDetailModal({super.key, required this.repo});

  static void show(BuildContext context, GithubRepo repo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RepoDetailModal(repo: repo),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final langColor = LanguageColors.getLanguageColor(repo.language);

    return Container(
      padding: const EdgeInsets.only(top: 12, left: 20, right: 20, bottom: 32),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Drag handle
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Repo name & badge
            Row(
              children: [
                Icon(
                  repo.isFork ? Icons.call_split_rounded : Icons.bookmark_border_rounded,
                  color: AppColors.githubBlue,
                  size: 22,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    repo.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w800,
                          fontSize: 20,
                        ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (repo.isArchived)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: AppColors.githubOrange.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(6),
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
            ),
            const SizedBox(height: 12),

            // Description
            Text(
              repo.description != null && repo.description!.trim().isNotEmpty
                  ? repo.description!.trim()
                  : 'No description provided for this repository.',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                    fontSize: 14,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 20),

            // Stats grid
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkCard : AppColors.lightCardHover,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat(context, '⭐ Stars', DateFormatter.formatNumber(repo.stargazersCount), isDark),
                  _buildStat(context, '🍴 Forks', DateFormatter.formatNumber(repo.forksCount), isDark),
                  _buildStat(context, '👁️ Watchers', DateFormatter.formatNumber(repo.watchersCount), isDark),
                  _buildStat(context, '❗ Issues', DateFormatter.formatNumber(repo.openIssuesCount), isDark),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Language, License, Updated Info
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                if (repo.language != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(color: langColor, shape: BoxShape.circle),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        repo.language!,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                        ),
                      ),
                    ],
                  ),
                if (repo.licenseName != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.verified_user_outlined, size: 15, color: AppColors.githubGreen),
                      const SizedBox(width: 4),
                      Text(
                        repo.licenseName!,
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                if (repo.updatedAt != null)
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.access_time_rounded,
                        size: 15,
                        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Updated ${DateFormatter.formatRelativeTime(repo.updatedAt)}',
                        style: TextStyle(
                          fontSize: 12.5,
                          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ),
              ],
            ),

            // Topics
            if (repo.topics.isNotEmpty) ...[
              const SizedBox(height: 16),
              Wrap(
                spacing: 6,
                runSpacing: 6,
                children: repo.topics.map((topic) {
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.githubBlue.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '#$topic',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: AppColors.githubBlue,
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 24),

            // Action: Open in GitHub
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.pop(context);
                  UrlHelper.launchURL(repo.htmlUrl);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.githubBlue,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                icon: const Icon(Icons.open_in_new_rounded, size: 18),
                label: const Text(
                  'Open in GitHub',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(BuildContext context, String label, String value, bool isDark) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
          ),
        ),
      ],
    );
  }
}
