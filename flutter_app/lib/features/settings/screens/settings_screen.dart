import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../shared/widgets/shared_widgets.dart';
import '../controllers/settings_controller.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsControllerProvider);
    final themeState = ref.watch(themeControllerProvider);
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightCard;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text('Settings',
                style: TextStyle(
                    fontSize: AppTypography.fontSize2xl,
                    fontWeight: AppTypography.fontWeightBold)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Appearance
                _Section('Appearance',
                    borderColor: borderColor,
                    cardColor: cardColor,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Theme',
                            style: TextStyle(
                                fontSize: AppTypography.fontSizeSm,
                                color: mutedColor)),
                        Row(
                          children: [
                            _ThemeBtn(
                              icon: Icons.light_mode,
                              label: 'Light',
                              selected:
                                  themeState.mode == AppThemeMode.light,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setTheme(AppThemeMode.light),
                            ),
                            const SizedBox(width: AppSpacing.sp2),
                            _ThemeBtn(
                              icon: Icons.dark_mode,
                              label: 'Dark',
                              selected:
                                  themeState.mode == AppThemeMode.dark,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setTheme(AppThemeMode.dark),
                            ),
                            const SizedBox(width: AppSpacing.sp2),
                            _ThemeBtn(
                              label: 'System',
                              selected:
                                  themeState.mode == AppThemeMode.system,
                              onTap: () => ref
                                  .read(themeControllerProvider.notifier)
                                  .setTheme(AppThemeMode.system),
                            ),
                          ],
                        ),
                      ],
                    )),
                const SizedBox(height: AppSpacing.sp6),
                _Section('Notifications',
                    borderColor: borderColor,
                    cardColor: cardColor,
                    child: Column(children: [
                      SettingToggle(
                        label: 'Push Notifications',
                        description:
                            'Receive notifications about new articles and trending content',
                        icon: Icons.notifications_outlined,
                        value: settings.notifications,
                        onChanged: (_) => ref
                            .read(settingsControllerProvider.notifier)
                            .toggle('notifications'),
                      ),
                      SettingToggle(
                        label: 'Email Digest',
                        description:
                            'Weekly digest of articles in your interests',
                        icon: Icons.email_outlined,
                        value: settings.emailDigest,
                        onChanged: (_) => ref
                            .read(settingsControllerProvider.notifier)
                            .toggle('emailDigest'),
                      ),
                    ])),
                const SizedBox(height: AppSpacing.sp6),
                _Section('Privacy',
                    borderColor: borderColor,
                    cardColor: cardColor,
                    child: Column(children: [
                      SettingToggle(
                        label: 'Private Profile',
                        description:
                            'Only you can see your profile and activity',
                        icon: Icons.lock_outline,
                        value: settings.privateProfile,
                        onChanged: (_) => ref
                            .read(settingsControllerProvider.notifier)
                            .toggle('privateProfile'),
                      ),
                      SettingToggle(
                        label: 'Show Activity Status',
                        description:
                            "Let others see when you're reading articles",
                        icon: Icons.storage_outlined,
                        value: settings.showActivity,
                        onChanged: (_) => ref
                            .read(settingsControllerProvider.notifier)
                            .toggle('showActivity'),
                      ),
                    ])),
                const SizedBox(height: AppSpacing.sp6),
                _Section('Data',
                    borderColor: borderColor,
                    cardColor: cardColor,
                    child: Column(children: [
                      _DataRow('Download Your Data', 'Export all your data',
                          onTap: () {}),
                      const SizedBox(height: AppSpacing.sp2),
                      _DataRow(
                          'Delete Account', 'Permanently delete',
                          onTap: () {}, isDestructive: true),
                    ])),
                const SizedBox(height: AppSpacing.sp6),
                _Section('About',
                    borderColor: borderColor,
                    cardColor: cardColor,
                    child: Column(children: [
                      _AboutRow('App Version', '2.6.0',
                          borderColor: borderColor, mutedColor: mutedColor),
                      _AboutRow('Build', '240310',
                          borderColor: borderColor, mutedColor: mutedColor),
                      _AboutRow('Last Updated', 'Mar 13, 2024',
                          borderColor: borderColor, mutedColor: mutedColor),
                    ])),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _Section extends StatelessWidget {
  final String title;
  final Widget child;
  final Color borderColor;
  final Color cardColor;

  const _Section(this.title,
      {required this.child,
      required this.borderColor,
      required this.cardColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: TextStyle(
                  fontSize: AppTypography.fontSizeLg,
                  fontWeight: AppTypography.fontWeightSemibold,
                  color: theme.colorScheme.onSurface)),
          const SizedBox(height: AppSpacing.sp4),
          child,
        ],
      ),
    );
  }
}

class _ThemeBtn extends StatelessWidget {
  final IconData? icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _ThemeBtn(
      {this.icon, required this.label, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp3, vertical: AppSpacing.sp2),
          decoration: BoxDecoration(
              color: selected ? theme.colorScheme.primary : mutedBg,
              borderRadius: BorderRadius.circular(AppRadius.lg)),
          child: Row(children: [
            if (icon != null) ...[
              Icon(icon, size: 16,
                  color: selected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onSurface),
              const SizedBox(width: AppSpacing.sp1),
            ],
            Text(label,
                style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    fontWeight: AppTypography.fontWeightMedium,
                    color: selected
                        ? theme.colorScheme.onPrimary
                        : theme.colorScheme.onSurface)),
          ]),
        ),
      ),
    );
  }
}

class _DataRow extends StatelessWidget {
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final bool isDestructive;

  const _DataRow(this.title, this.subtitle,
      {required this.onTap, this.isDestructive = false});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp4, vertical: AppSpacing.sp3),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title,
                  style: TextStyle(
                      fontSize: AppTypography.fontSizeSm,
                      fontWeight: AppTypography.fontWeightMedium,
                      color: isDestructive
                          ? AppColors.likeRed
                          : theme.colorScheme.onSurface)),
              Text(subtitle,
                  style: TextStyle(
                      fontSize: AppTypography.fontSizeXs,
                      color: isDestructive
                          ? AppColors.likeRed.withOpacity(0.7)
                          : mutedColor)),
            ],
          ),
        ),
      ),
    );
  }
}

class _AboutRow extends StatelessWidget {
  final String label;
  final String value;
  final Color borderColor;
  final Color mutedColor;

  const _AboutRow(this.label, this.value,
      {required this.borderColor, required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp2),
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: borderColor))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  color: mutedColor)),
          Text(value,
              style: TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  fontWeight: AppTypography.fontWeightMedium,
                  color: theme.colorScheme.onSurface)),
        ],
      ),
    );
  }
}
