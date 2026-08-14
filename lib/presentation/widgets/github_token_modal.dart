import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/constants/app_colors.dart';
import '../../core/di/injection_container.dart';
import '../../core/utils/url_helper.dart';

class GithubTokenModal extends StatefulWidget {
  const GithubTokenModal({super.key});

  static Future<void> show(BuildContext context) async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const GithubTokenModal(),
    );
  }

  @override
  State<GithubTokenModal> createState() => _GithubTokenModalState();
}

class _GithubTokenModalState extends State<GithubTokenModal> {
  late final TextEditingController _tokenController;
  bool _obscureText = true;
  String _savedToken = '';

  @override
  void initState() {
    super.initState();
    _tokenController = TextEditingController();
    _loadCurrentToken();
  }

  void _loadCurrentToken() {
    final prefs = sl<SharedPreferences>();
    _savedToken = prefs.getString('github_token') ?? '';
    _tokenController.text = _savedToken;
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _saveToken() async {
    final prefs = sl<SharedPreferences>();
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      await prefs.remove('github_token');
    } else {
      await prefs.setString('github_token', token);
    }

    if (mounted) {
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            token.isEmpty
                ? 'GitHub Token removed. Rate limit is 60 req/hr.'
                : 'GitHub Token saved! Rate limit upgraded to 5,000 req/hr.',
          ),
          backgroundColor: token.isEmpty ? AppColors.githubOrange : AppColors.githubGreen,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, 24 + bottomInset),
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
            // Handle
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

            // Title
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.githubYellow.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.key_rounded,
                    color: AppColors.githubYellow,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'GitHub API Token',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 18,
                            ),
                      ),
                      Text(
                        'Upgrade from 60 to 5,000 req/hr',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              'To avoid GitHub API 403 Rate Limit errors, paste your GitHub Personal Access Token (classic or fine-grained with public read access).',
              style: TextStyle(
                fontSize: 13,
                color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 14),

            // Text Field
            TextField(
              controller: _tokenController,
              obscureText: _obscureText,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: 'ghp_xxxxxxxxxxxxxxxxxxxx',
                hintStyle: TextStyle(
                  color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                  fontSize: 13,
                ),
                prefixIcon: const Icon(Icons.password_rounded, size: 20),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureText ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                    size: 18,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscureText = !_obscureText;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Helper link
            InkWell(
              onTap: () => UrlHelper.launchURL('https://github.com/settings/tokens'),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.githubBlue),
                  const SizedBox(width: 6),
                  Text(
                    'Generate a free token on GitHub.com',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.githubBlue,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                if (_savedToken.isNotEmpty) ...[
                  OutlinedButton(
                    onPressed: () {
                      _tokenController.clear();
                      _saveToken();
                    },
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.githubRed,
                      side: const BorderSide(color: AppColors.githubRed),
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Clear Token'),
                  ),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: ElevatedButton(
                    onPressed: _saveToken,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.githubBlue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text(
                      'Save & Apply',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
