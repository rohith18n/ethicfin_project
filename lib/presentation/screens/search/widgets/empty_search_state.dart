import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class EmptySearchState extends StatelessWidget {
  final ValueChanged<String> onSelectSuggestion;

  const EmptySearchState({
    super.key,
    required this.onSelectSuggestion,
  });

  static const List<Map<String, String>> suggestions = [
    {'username': 'flutter', 'role': 'Framework'},
    {'username': 'torvalds', 'role': 'Linux Creator'},
    {'username': 'google', 'role': 'Organization'},
    {'username': 'shadcn', 'role': 'UI Creator'},
    {'username': 'mitchellh', 'role': 'HashiCorp / Ghostty'},
    {'username': 'antfu', 'role': 'Vue / Vite Team'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  colors: [AppColors.githubBlue, AppColors.githubPurple],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.githubBlue.withValues(alpha: 0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: const Icon(
                Icons.hub_rounded,
                size: 40,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Explore GitHub Universe',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Search any developer or organization profile to inspect their repositories, stats, languages, and contributions.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
            ),
            const SizedBox(height: 28),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                children: [
                  const Icon(Icons.trending_up_rounded, size: 16, color: AppColors.githubOrange),
                  const SizedBox(width: 6),
                  Text(
                    'Popular profiles to explore:',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: suggestions.map((item) {
                final username = item['username']!;
                final role = item['role']!;
                return ActionChip(
                  avatar: CircleAvatar(
                    backgroundColor: AppColors.githubBlue.withValues(alpha: 0.15),
                    child: Text(
                      username[0].toUpperCase(),
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: AppColors.githubBlue,
                      ),
                    ),
                  ),
                  label: Text.rich(
                    TextSpan(
                      text: username,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                      children: [
                        TextSpan(
                          text: ' ($role)',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w400,
                            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  side: BorderSide(
                    color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onPressed: () => onSelectSuggestion(username),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}
