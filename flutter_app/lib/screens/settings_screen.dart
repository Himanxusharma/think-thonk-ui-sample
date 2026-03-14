import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import '../providers/theme_provider.dart';
import '../widgets/common/app_switch.dart';

/// Settings screen
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final Map<String, bool> _settings = {
    'notifications': true,
    'emailDigest': false,
    'privateProfile': false,
    'showActivity': true,
  };

  void _toggleSetting(String key) {
    setState(() {
      _settings[key] = !_settings[key]!;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeState = ref.watch(themeProvider);
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
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // Header
          SliverAppBar(
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor.withOpacity(0.8),
            leading: IconButton(
              onPressed: () => Navigator.of(context).pop(),
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text(
              'Settings',
              style: TextStyle(
                fontSize: AppTypography.fontSize2xl,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Theme Section
                _buildSection(
                  'Appearance',
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Theme',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeSm,
                              color: mutedColor,
                            ),
                          ),
                          Row(
                            children: [
                              _buildThemeButton(
                                icon: Icons.light_mode,
                                label: 'Light',
                                isSelected: themeState.mode == AppThemeMode.light,
                                onTap: () => ref.read(themeProvider.notifier)
                                    .setTheme(AppThemeMode.light),
                              ),
                              const SizedBox(width: AppSpacing.sp2),
                              _buildThemeButton(
                                icon: Icons.dark_mode,
                                label: 'Dark',
                                isSelected: themeState.mode == AppThemeMode.dark,
                                onTap: () => ref.read(themeProvider.notifier)
                                    .setTheme(AppThemeMode.dark),
                              ),
                              const SizedBox(width: AppSpacing.sp2),
                              _buildThemeButton(
                                label: 'System',
                                isSelected: themeState.mode == AppThemeMode.system,
                                onTap: () => ref.read(themeProvider.notifier)
                                    .setTheme(AppThemeMode.system),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // Notifications Section
                _buildSection(
                  'Notifications',
                  child: Column(
                    children: [
                      SettingToggle(
                        label: 'Push Notifications',
                        description: 'Receive notifications about new articles and trending content',
                        icon: Icons.notifications_outlined,
                        value: _settings['notifications']!,
                        onChanged: (_) => _toggleSetting('notifications'),
                      ),
                      SettingToggle(
                        label: 'Email Digest',
                        description: 'Weekly digest of articles in your interests',
                        icon: Icons.notifications_outlined,
                        value: _settings['emailDigest']!,
                        onChanged: (_) => _toggleSetting('emailDigest'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // Privacy Section
                _buildSection(
                  'Privacy',
                  child: Column(
                    children: [
                      SettingToggle(
                        label: 'Private Profile',
                        description: 'Only you can see your profile and activity',
                        icon: Icons.lock_outline,
                        value: _settings['privateProfile']!,
                        onChanged: (_) => _toggleSetting('privateProfile'),
                      ),
                      SettingToggle(
                        label: 'Show Activity Status',
                        description: "Let others see when you're reading articles",
                        icon: Icons.storage_outlined,
                        value: _settings['showActivity']!,
                        onChanged: (_) => _toggleSetting('showActivity'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // Data Section
                _buildSection(
                  'Data',
                  child: Column(
                    children: [
                      _buildDataButton(
                        'Download Your Data',
                        'Export all your data',
                        onTap: () {},
                      ),
                      const SizedBox(height: AppSpacing.sp2),
                      _buildDataButton(
                        'Delete Account',
                        'Permanently delete',
                        onTap: () {},
                        isDestructive: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // About Section
                _buildSection(
                  'About',
                  child: Column(
                    children: [
                      _buildAboutRow('App Version', '2.6.0'),
                      _buildAboutRow('Build', '240310'),
                      _buildAboutRow('Last Updated', 'Mar 13, 2024'),
                    ],
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSection(String title, {required Widget child}) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final cardColor = theme.brightness == Brightness.dark
        ? AppColors.darkCard
        : AppColors.lightCard;

    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp6),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: AppTypography.fontSizeLg,
              fontWeight: AppTypography.fontWeightSemibold,
              color: theme.colorScheme.onBackground,
            ),
          ),
          const SizedBox(height: AppSpacing.sp4),
          child,
        ],
      ),
    );
  }

  Widget _buildThemeButton({
    IconData? icon,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
            horizontal: AppSpacing.sp3,
            vertical: AppSpacing.sp2,
          ),
          decoration: BoxDecoration(
            color: isSelected 
                ? theme.colorScheme.primary 
                : mutedBg,
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          child: Row(
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  size: 16,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onBackground,
                ),
                const SizedBox(width: AppSpacing.sp1),
              ],
              Text(
                label,
                style: TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  fontWeight: AppTypography.fontWeightMedium,
                  color: isSelected
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.onBackground,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataButton(
    String title,
    String subtitle, {
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
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
            horizontal: AppSpacing.sp4,
            vertical: AppSpacing.sp3,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: AppTypography.fontSizeSm,
                  fontWeight: AppTypography.fontWeightMedium,
                  color: isDestructive 
                      ? AppColors.likeRed 
                      : theme.colorScheme.onBackground,
                ),
              ),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: AppTypography.fontSizeXs,
                  color: isDestructive 
                      ? AppColors.likeRed.withOpacity(0.7) 
                      : mutedColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAboutRow(String label, String value) {
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp2),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: borderColor),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              color: mutedColor,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              fontWeight: AppTypography.fontWeightMedium,
              color: theme.colorScheme.onBackground,
            ),
          ),
        ],
      ),
    );
  }
}
