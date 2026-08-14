import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';

class StatBadge extends StatelessWidget {
  final String label;
  final int count;
  final IconData icon;
  final Color? color;
  final VoidCallback? onTap;

  const StatBadge({
    super.key,
    required this.label,
    required this.count,
    required this.icon,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final accentColor = color ?? AppColors.githubBlue;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkCard : AppColors.lightCardHover,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
              width: 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(icon, size: 16, color: accentColor),
                  const SizedBox(width: 6),
                  Text(
                    DateFormatter.formatNumber(count),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      fontSize: 11,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
