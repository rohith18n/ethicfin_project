import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_colors.dart';

class CustomAvatar extends StatelessWidget {
  final String imageUrl;
  final double size;
  final double borderRadius;
  final bool hasBorder;

  const CustomAvatar({
    super.key,
    required this.imageUrl,
    this.size = 80,
    this.borderRadius = 40,
    this.hasBorder = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        border: hasBorder
            ? Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
                width: 2,
              )
            : null,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius - (hasBorder ? 2 : 0)),
        child: imageUrl.isEmpty
            ? _buildPlaceholder(context)
            : CachedNetworkImage(
                imageUrl: imageUrl,
                fit: BoxFit.cover,
                placeholder: (context, url) => Shimmer.fromColors(
                  baseColor: isDark ? AppColors.darkCard : Colors.grey[300]!,
                  highlightColor: isDark ? AppColors.darkCardHover : Colors.grey[100]!,
                  child: Container(color: Colors.white),
                ),
                errorWidget: (context, url, error) => _buildPlaceholder(context),
              ),
      ),
    );
  }

  Widget _buildPlaceholder(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      color: isDark ? AppColors.darkCard : AppColors.lightCardHover,
      child: Icon(
        Icons.person_rounded,
        size: size * 0.55,
        color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
      ),
    );
  }
}
