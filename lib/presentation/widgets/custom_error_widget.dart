import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/errors/failures.dart';
import 'github_token_modal.dart';

class CustomErrorWidget extends StatelessWidget {
  final AppFailure? failure;
  final String? message;
  final VoidCallback? onRetry;

  const CustomErrorWidget({
    super.key,
    this.failure,
    this.message,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRateLimit = failure is RateLimitFailure;

    IconData iconData = Icons.error_outline_rounded;
    Color iconColor = AppColors.githubRed;
    String title = 'Something went wrong';
    String description = message ?? failure?.message ?? 'An unexpected error occurred.';

    if (failure is UserNotFoundFailure) {
      iconData = Icons.person_off_rounded;
      iconColor = AppColors.githubOrange;
      title = 'User Not Found';
      description = 'We couldn\'t find any GitHub user with this username. Please double check the spelling and try again.';
    } else if (failure is RateLimitFailure) {
      iconData = Icons.hourglass_top_rounded;
      iconColor = AppColors.githubYellow;
      title = 'Rate Limit Reached';
    } else if (failure is NetworkFailure) {
      iconData = Icons.wifi_off_rounded;
      iconColor = AppColors.githubBlue;
      title = 'No Internet Connection';
      description = 'Please check your Wi-Fi or mobile data network connection and try again.';
    } else if (failure is TimeoutFailure) {
      iconData = Icons.timer_outlined;
      iconColor = AppColors.githubOrange;
      title = 'Request Timed Out';
      description = 'The server took too long to respond. Please check your connection and retry.';
    } else if (failure is ServerFailure) {
      iconData = Icons.cloud_off_rounded;
      iconColor = AppColors.githubRed;
      title = 'GitHub Server Error';
      description = 'GitHub is currently experiencing technical difficulties. Please check back shortly.';
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 32,
                  color: iconColor,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
              ),
              const SizedBox(height: 20),
              if (isRateLimit) ...[
                ElevatedButton.icon(
                  onPressed: () async {
                    await GithubTokenModal.show(context);
                    if (onRetry != null) onRetry!();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.githubYellow,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.key_rounded, size: 18),
                  label: const Text(
                    'Add API Token (5,000 req/hr)',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ),
                const SizedBox(height: 10),
              ],
              if (onRetry != null)
                FilledButton.icon(
                  onPressed: onRetry,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.githubBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.refresh_rounded, size: 18),
                  label: const Text('Try Again', style: TextStyle(fontWeight: FontWeight.w600)),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
