import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class RecentSearchesWidget extends StatelessWidget {
  final List<String> recentSearches;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onRemove;
  final VoidCallback onClearAll;

  const RecentSearchesWidget({
    super.key,
    required this.recentSearches,
    required this.onSelect,
    required this.onRemove,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    if (recentSearches.isEmpty) return const SizedBox.shrink();

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.history_rounded,
                    size: 18,
                    color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Recent Searches',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ],
              ),
              TextButton(
                onPressed: onClearAll,
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: Text(
                  'Clear all',
                  style: TextStyle(
                    fontSize: 12,
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: recentSearches.map((username) {
              return InputChip(
                avatar: Icon(
                  Icons.account_circle_outlined,
                  size: 16,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                label: Text(
                  username,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                ),
                backgroundColor: isDark ? AppColors.darkCard : AppColors.lightCardHover,
                side: BorderSide(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                deleteIcon: const Icon(Icons.close_rounded, size: 14),
                onDeleted: () => onRemove(username),
                onPressed: () => onSelect(username),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
