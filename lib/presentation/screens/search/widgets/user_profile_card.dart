import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/utils/url_helper.dart';
import '../../../../domain/entities/github_user.dart';
import '../../../widgets/custom_avatar.dart';
import 'profile_stats_row.dart';

class UserProfileCard extends StatelessWidget {
  final GithubUser user;
  final VoidCallback onViewRepos;

  const UserProfileCard({
    super.key,
    required this.user,
    required this.onViewRepos,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Background Gradient + Avatar
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF1F2937), const Color(0xFF111827)]
                    : [const Color(0xFFF3F4F6), const Color(0xFFE5E7EB)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'user_avatar_${user.login}',
                  child: CustomAvatar(
                    imageUrl: user.avatarUrl,
                    size: 74,
                    borderRadius: 37,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (user.hireable == true)
                        Container(
                          margin: const EdgeInsets.only(bottom: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.githubGreen.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: AppColors.githubGreen.withValues(alpha: 0.4),
                              width: 1,
                            ),
                          ),
                          child: const Text(
                            'Available for hire',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w700,
                              color: AppColors.githubGreen,
                            ),
                          ),
                        ),
                      Text(
                        user.displayName,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w800,
                              fontSize: 20,
                            ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '@${user.login}',
                            style: TextStyle(
                              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                          if (user.type == 'Organization') ...[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: AppColors.githubPurple.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: const Text(
                                'Org',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.githubPurple,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Bio
                if (user.bio != null && user.bio!.trim().isNotEmpty) ...[
                  Text(
                    user.bio!.trim(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
                          fontSize: 14,
                          height: 1.4,
                        ),
                  ),
                  const SizedBox(height: 16),
                ],

                // Metadata Details: Company, Location, Blog, Twitter, Joined
                _buildMetadataList(context, isDark),
                const SizedBox(height: 20),

                // Stats Cards
                ProfileStatsRow(
                  user: user,
                  onViewRepos: onViewRepos,
                ),
                const SizedBox(height: 20),

                // CTA Button: View Repositories
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: onViewRepos,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.githubBlue,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 2,
                        ),
                        icon: const Icon(Icons.folder_shared_outlined, size: 18),
                        label: Text(
                          'View Repositories (${user.publicRepos})',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filledTonal(
                      onPressed: () => UrlHelper.launchURL(user.htmlUrl),
                      tooltip: 'Open in GitHub',
                      style: IconButton.styleFrom(
                        padding: const EdgeInsets.all(14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      icon: const Icon(Icons.open_in_new_rounded, size: 20),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetadataList(BuildContext context, bool isDark) {
    final textColor = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Wrap(
      spacing: 16,
      runSpacing: 10,
      children: [
        if (user.company != null && user.company!.trim().isNotEmpty)
          _buildMetaItem(Icons.business_rounded, user.company!.trim(), textColor),
        if (user.location != null && user.location!.trim().isNotEmpty)
          _buildMetaItem(Icons.location_on_outlined, user.location!.trim(), textColor),
        if (user.blog != null && user.blog!.trim().isNotEmpty)
          InkWell(
            onTap: () => UrlHelper.launchURL(user.blog!),
            child: _buildMetaItem(Icons.link_rounded, user.blog!.trim(), AppColors.githubBlue),
          ),
        if (user.twitterUsername != null && user.twitterUsername!.trim().isNotEmpty)
          InkWell(
            onTap: () => UrlHelper.launchURL('https://x.com/${user.twitterUsername}'),
            child: _buildMetaItem(Icons.alternate_email_rounded, user.twitterUsername!.trim(), AppColors.githubBlue),
          ),
        if (user.createdAt != null)
          _buildMetaItem(
            Icons.calendar_today_outlined,
            'Joined ${DateFormatter.formatJoinedDate(user.createdAt)}',
            textColor,
          ),
      ],
    );
  }

  Widget _buildMetaItem(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: color),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w500,
              color: color,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
