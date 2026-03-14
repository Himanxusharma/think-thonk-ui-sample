import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Category badge widget
class CategoryBadge extends StatelessWidget {
  final String category;
  final bool isPrimary;

  const CategoryBadge({
    super.key,
    required this.category,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    if (isPrimary) {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sp2,
          vertical: AppSpacing.sp1,
        ),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(AppRadius.sm),
        ),
        child: Text(
          category,
          style: TextStyle(
            fontSize: AppTypography.fontSizeXs,
            fontWeight: AppTypography.fontWeightMedium,
            color: theme.colorScheme.primary,
          ),
        ),
      );
    }

    return Text(
      category.toUpperCase(),
      style: TextStyle(
        fontSize: AppTypography.fontSizeXs,
        fontWeight: AppTypography.fontWeightMedium,
        color: mutedColor,
        letterSpacing: 0.5,
      ),
    );
  }
}
