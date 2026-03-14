import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Custom switch/toggle component
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: AppAnimations.fast,
        width: 44,
        height: 24,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: value ? theme.colorScheme.primary : mutedColor,
        ),
        child: AnimatedAlign(
          duration: AppAnimations.fast,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 16,
            height: 16,
            margin: const EdgeInsets.symmetric(horizontal: 4),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

/// Setting item with toggle
class SettingToggle extends StatelessWidget {
  final String label;
  final String description;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const SettingToggle({
    super.key,
    required this.label,
    required this.description,
    required this.icon,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp4),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sp2),
            decoration: BoxDecoration(
              color: mutedBg,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(
              icon,
              size: 20,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(width: AppSpacing.sp3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontWeight: AppTypography.fontWeightMedium,
                    color: theme.colorScheme.onBackground,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    color: mutedColor,
                  ),
                ),
              ],
            ),
          ),
          AppSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
