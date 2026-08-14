import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../domain/entities/github_user.dart';
import '../../../widgets/stat_badge.dart';

class ProfileStatsRow extends StatelessWidget {
  final GithubUser user;
  final VoidCallback onViewRepos;

  const ProfileStatsRow({
    super.key,
    required this.user,
    required this.onViewRepos,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: StatBadge(
            label: 'Repos',
            count: user.publicRepos,
            icon: Icons.folder_copy_outlined,
            color: AppColors.githubBlue,
            onTap: onViewRepos,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: 'Followers',
            count: user.followers,
            icon: Icons.people_outline_rounded,
            color: AppColors.githubPurple,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: StatBadge(
            label: 'Following',
            count: user.following,
            icon: Icons.person_add_alt_1_outlined,
            color: AppColors.githubGreen,
          ),
        ),
      ],
    );
  }
}
