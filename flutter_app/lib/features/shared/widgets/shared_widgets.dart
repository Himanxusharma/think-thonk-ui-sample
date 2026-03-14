import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

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
    final foreground = theme.colorScheme.onSurface;

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

/// Custom text input field
class AppInput extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? placeholder;
  final IconData? prefixIcon;
  final Widget? suffix;
  final bool obscureText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final void Function(String)? onChanged;
  final int maxLines;

  const AppInput({
    super.key,
    this.controller,
    this.label,
    this.placeholder,
    this.prefixIcon,
    this.suffix,
    this.obscureText = false,
    this.keyboardType,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null) ...[
          Text(
            label!,
            style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              fontWeight: AppTypography.fontWeightMedium,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: AppSpacing.sp2),
        ],
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          validator: validator,
          onChanged: onChanged,
          maxLines: maxLines,
          style: TextStyle(
            fontSize: AppTypography.fontSizeSm,
            color: theme.colorScheme.onSurface,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(color: mutedColor),
            prefixIcon: prefixIcon != null
                ? Icon(prefixIcon, size: 20, color: mutedColor)
                : null,
            suffixIcon: suffix,
            contentPadding: EdgeInsets.symmetric(
              horizontal: prefixIcon != null ? 0 : AppSpacing.sp4,
              vertical: AppSpacing.sp3,
            ),
          ),
        ),
      ],
    );
  }
}

/// Custom toggle/switch
class AppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const AppSwitch({super.key, required this.value, required this.onChanged});

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

/// Setting row with toggle
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
        border: Border(bottom: BorderSide(color: borderColor)),
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
            child: Icon(icon, size: 20, color: theme.colorScheme.onSurface),
          ),
          const SizedBox(width: AppSpacing.sp3),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: TextStyle(
                      fontWeight: AppTypography.fontWeightMedium,
                      color: theme.colorScheme.onSurface,
                    )),
                const SizedBox(height: 2),
                Text(description,
                    style: TextStyle(
                      fontSize: AppTypography.fontSizeSm,
                      color: mutedColor,
                    )),
              ],
            ),
          ),
          AppSwitch(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
