import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/language_colors.dart';
import '../../../blocs/repositories/repositories_event.dart';

class RepoSortFilterBar extends StatelessWidget {
  final List<String> availableLanguages;
  final String? selectedLanguage;
  final RepoSortOption selectedSort;
  final ValueChanged<String?> onSelectLanguage;
  final ValueChanged<RepoSortOption> onSelectSort;
  final VoidCallback onClearAll;

  const RepoSortFilterBar({
    super.key,
    required this.availableLanguages,
    required this.selectedLanguage,
    required this.selectedSort,
    required this.onSelectLanguage,
    required this.onSelectSort,
    required this.onClearAll,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sort Row Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Icon(
                  Icons.sort_rounded,
                  size: 18,
                  color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                ),
                const SizedBox(width: 6),
                Text(
                  'Sort by',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary,
                      ),
                ),
              ],
            ),
            // Sort Dropdown Selector
            Container(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                ),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<RepoSortOption>(
                  value: selectedSort,
                  icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 16),
                  borderRadius: BorderRadius.circular(12),
                  dropdownColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                  items: RepoSortOption.values.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(option.icon, style: const TextStyle(fontSize: 13)),
                          const SizedBox(width: 6),
                          Text(
                            option.label,
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) onSelectSort(val);
                  },
                ),
              ),
            ),
          ],
        ),

        // Language Filter Chips
        if (availableLanguages.isNotEmpty) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 34,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                // "All" chip
                Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: const Text('All Languages', style: TextStyle(fontSize: 12)),
                    selected: selectedLanguage == null,
                    showCheckmark: false,
                    backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                    selectedColor: AppColors.githubBlue.withValues(alpha: 0.2),
                    side: BorderSide(
                      color: selectedLanguage == null
                          ? AppColors.githubBlue
                          : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                    ),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    onSelected: (_) => onSelectLanguage(null),
                  ),
                ),
                ...availableLanguages.map((lang) {
                  final isSelected = selectedLanguage?.toLowerCase() == lang.toLowerCase();
                  final langColor = LanguageColors.getLanguageColor(lang);

                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: FilterChip(
                      avatar: Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: langColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      label: Text(lang, style: const TextStyle(fontSize: 12)),
                      selected: isSelected,
                      showCheckmark: false,
                      backgroundColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
                      selectedColor: langColor.withValues(alpha: 0.2),
                      side: BorderSide(
                        color: isSelected
                            ? langColor
                            : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                      ),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      onSelected: (selected) {
                        onSelectLanguage(selected ? lang : null);
                      },
                    ),
                  );
                }),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
