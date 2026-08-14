import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class SearchBarWidget extends StatefulWidget {
  final TextEditingController controller;
  final ValueChanged<String> onSubmitted;
  final VoidCallback onClear;
  final bool isLoading;

  const SearchBarWidget({
    super.key,
    required this.controller,
    required this.onSubmitted,
    required this.onClear,
    this.isLoading = false,
  });

  @override
  State<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends State<SearchBarWidget> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final hasText = widget.controller.text.isNotEmpty;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: widget.controller,
        textInputAction: TextInputAction.search,
        onSubmitted: widget.onSubmitted,
        textAlignVertical: TextAlignVertical.center,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 15,
            ),
        decoration: InputDecoration(
          isDense: true,
          hintText: 'Search GitHub username...',
          hintStyle: TextStyle(
            color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 14, right: 10),
            child: Icon(
              Icons.search_rounded,
              color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
              size: 20,
            ),
          ),
          prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 44),
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 6),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (hasText)
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 16),
                    tooltip: 'Clear',
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                    color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
                    onPressed: widget.onClear,
                  ),
                const SizedBox(width: 4),
                IconButton.filled(
                  onPressed: widget.isLoading
                      ? null
                      : () => widget.onSubmitted(widget.controller.text),
                  tooltip: 'Search',
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.githubBlue,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(36, 36),
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  icon: widget.isLoading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        )
                      : const Icon(Icons.arrow_forward_rounded, size: 18),
                ),
              ],
            ),
          ),
          suffixIconConstraints: const BoxConstraints(minHeight: 44),
          filled: false,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        ),
      ),
    );
  }
}
