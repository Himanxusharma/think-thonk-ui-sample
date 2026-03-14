import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Reusable action button widget (Save, Like, Share, Focus)
class ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final int? count;
  final bool isActive;
  final Color? activeColor;
  final VoidCallback onPressed;

  const ActionButton({
    super.key,
    required this.icon,
    required this.label,
    this.count,
    this.isActive = false,
    this.activeColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;
    final foreground = theme.colorScheme.onBackground;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sp2,
            vertical: AppSpacing.sp1,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 24,
                color: isActive ? (activeColor ?? foreground) : mutedColor,
              ),
              const SizedBox(height: AppSpacing.sp1),
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTypography.fontSizeXs,
                  color: mutedColor,
                ),
              ),
              if (count != null) ...[
                const SizedBox(height: 2),
                Text(
                  count.toString(),
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeXs,
                    color: mutedColor.withOpacity(0.6),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
