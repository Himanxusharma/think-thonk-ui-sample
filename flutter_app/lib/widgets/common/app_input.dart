import 'package:flutter/material.dart';
import '../../core/constants/app_constants.dart';

/// Custom input field with icon support
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
              color: theme.colorScheme.onBackground,
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
            color: theme.colorScheme.onBackground,
          ),
          decoration: InputDecoration(
            hintText: placeholder,
            hintStyle: TextStyle(
              color: mutedColor,
            ),
            prefixIcon: prefixIcon != null
                ? Icon(
                    prefixIcon,
                    size: 20,
                    color: mutedColor,
                  )
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
