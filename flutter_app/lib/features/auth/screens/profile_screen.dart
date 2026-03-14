import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';
import '../../shared/widgets/shared_widgets.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  bool _isEditing = false;
  late Map<String, String> _profile;
  late Map<String, String> _editForm;

  @override
  void initState() {
    super.initState();
    _profile = {
      'name': 'Demo User',
      'email': 'demo@thinkthonk.com',
      'bio':
          'Passionate reader and thinker exploring ideas across psychology, science, and philosophy.',
      'location': 'San Francisco, CA',
      'joinDate': 'Jan 15, 2024',
    };
    _editForm = Map.from(_profile);
  }

  void _handleSave() =>
      setState(() {
        _profile = Map.from(_editForm);
        _isEditing = false;
      });

  void _handleCancel() =>
      setState(() {
        _editForm = Map.from(_profile);
        _isEditing = false;
      });

  Future<void> _handleLogout() async {
    await ref.read(authControllerProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (_) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
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

    if (authState.user != null) {
      _profile['name'] = authState.user!.name;
      _profile['email'] = authState.user!.email;
    }

    final isAdmin = authState.user?.isAdmin ?? false;

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
            title: const Text('Profile',
                style: TextStyle(
                    fontSize: AppTypography.fontSize2xl,
                    fontWeight: AppTypography.fontWeightBold)),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                // Profile card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.sp6),
                  decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: borderColor)),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                                color: theme.colorScheme.primary
                                    .withOpacity(0.1),
                                shape: BoxShape.circle),
                            alignment: Alignment.center,
                            child: Text(
                              _profile['name']!
                                  .split(' ')
                                  .map((n) => n[0])
                                  .take(2)
                                  .join(),
                              style: TextStyle(
                                  fontSize: AppTypography.fontSize2xl,
                                  fontWeight: AppTypography.fontWeightBold,
                                  color: theme.colorScheme.primary),
                            ),
                          ),
                          const SizedBox(width: AppSpacing.sp4),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(_profile['name']!,
                                    style: TextStyle(
                                        fontSize: AppTypography.fontSizeXl,
                                        fontWeight:
                                            AppTypography.fontWeightBold,
                                        color:
                                            theme.colorScheme.onSurface)),
                                Text(_profile['email']!,
                                    style: TextStyle(
                                        fontSize: AppTypography.fontSizeSm,
                                        color: mutedColor)),
                              ],
                            ),
                          ),
                          if (!_isEditing)
                            IconButton(
                              onPressed: () =>
                                  setState(() => _isEditing = true),
                              icon: const Icon(Icons.edit_outlined, size: 20),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.sp6),
                      if (_isEditing) ...[
                        AppInput(
                          controller: TextEditingController(
                              text: _editForm['name']),
                          label: 'Full Name',
                          onChanged: (v) => _editForm['name'] = v,
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        AppInput(
                          controller: TextEditingController(
                              text: _editForm['bio']),
                          label: 'Bio',
                          maxLines: 3,
                          onChanged: (v) => _editForm['bio'] = v,
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        AppInput(
                          controller: TextEditingController(
                              text: _editForm['location']),
                          label: 'Location',
                          onChanged: (v) => _editForm['location'] = v,
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        Row(
                          children: [
                            Expanded(
                                child: ElevatedButton(
                                    onPressed: _handleSave,
                                    child: const Text('Save Changes'))),
                            const SizedBox(width: AppSpacing.sp2),
                            Expanded(
                                child: OutlinedButton(
                                    onPressed: _handleCancel,
                                    child: const Text('Cancel'))),
                          ],
                        ),
                      ] else ...[
                        _InfoSection('Bio', _profile['bio']!,
                            mutedColor: mutedColor),
                        const SizedBox(height: AppSpacing.sp4),
                        Row(
                          children: [
                            Expanded(
                                child: _InfoWithIcon(
                                    Icons.location_on_outlined,
                                    'Location',
                                    _profile['location']!,
                                    mutedColor: mutedColor)),
                            Expanded(
                                child: _InfoWithIcon(
                                    Icons.calendar_today_outlined,
                                    'Joined',
                                    _profile['joinDate']!,
                                    mutedColor: mutedColor)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.sp6),

                // Stats
                Row(
                  children: [
                    Expanded(
                        child: _StatCard('145', 'Articles Liked',
                            theme.colorScheme.primary,
                            borderColor: borderColor,
                            cardColor: cardColor,
                            mutedColor: mutedColor)),
                    const SizedBox(width: AppSpacing.sp4),
                    Expanded(
                        child: _StatCard('32', 'Saved',
                            theme.colorScheme.primary,
                            borderColor: borderColor,
                            cardColor: cardColor,
                            mutedColor: mutedColor)),
                    const SizedBox(width: AppSpacing.sp4),
                    Expanded(
                        child: _StatCard(
                            '8', 'Current Streak', AppColors.streakOrange,
                            borderColor: borderColor,
                            cardColor: cardColor,
                            mutedColor: mutedColor)),
                  ],
                ),
                const SizedBox(height: AppSpacing.sp6),

                if (isAdmin) ...[
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton.icon(
                      onPressed: () =>
                          Navigator.of(context).pushNamed('/admin'),
                      icon: const Icon(Icons.flash_on, size: 16),
                      label: const Text('Admin Dashboard'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.colorScheme.primary,
                        side: BorderSide(
                            color: theme.colorScheme.primary.withOpacity(0.2)),
                        backgroundColor:
                            theme.colorScheme.primary.withOpacity(0.1),
                        padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.sp3),
                      ),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp3),
                ],

                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: _handleLogout,
                    icon: const Icon(Icons.logout, size: 16),
                    label: const Text('Logout'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.likeRed,
                      side: BorderSide(
                          color: AppColors.likeRed.withOpacity(0.2)),
                      backgroundColor: AppColors.likeRed.withOpacity(0.1),
                      padding: const EdgeInsets.symmetric(
                          vertical: AppSpacing.sp3),
                    ),
                  ),
                ),
              ]),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoSection extends StatelessWidget {
  final String label;
  final String value;
  final Color mutedColor;
  const _InfoSection(this.label, this.value, {required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(label.toUpperCase(),
          style: TextStyle(
              fontSize: AppTypography.fontSizeXs,
              fontWeight: AppTypography.fontWeightMedium,
              color: mutedColor,
              letterSpacing: 0.5)),
      const SizedBox(height: AppSpacing.sp1),
      Text(value,
          style: TextStyle(
              fontSize: AppTypography.fontSizeSm,
              color: theme.colorScheme.onSurface)),
    ]);
  }
}

class _InfoWithIcon extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color mutedColor;
  const _InfoWithIcon(this.icon, this.label, this.value,
      {required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(children: [
      Icon(icon, size: 16, color: mutedColor),
      const SizedBox(width: AppSpacing.sp2),
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(label.toUpperCase(),
            style: TextStyle(
                fontSize: AppTypography.fontSizeXs,
                fontWeight: AppTypography.fontWeightMedium,
                color: mutedColor,
                letterSpacing: 0.5)),
        Text(value,
            style: TextStyle(
                fontSize: AppTypography.fontSizeSm,
                color: theme.colorScheme.onSurface)),
      ]),
    ]);
  }
}

class _StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color color;
  final Color borderColor;
  final Color cardColor;
  final Color mutedColor;

  const _StatCard(this.value, this.label, this.color,
      {required this.borderColor,
      required this.cardColor,
      required this.mutedColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.sp4),
      decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor)),
      child: Column(children: [
        Text(value,
            style: TextStyle(
                fontSize: AppTypography.fontSize2xl,
                fontWeight: AppTypography.fontWeightBold,
                color: color)),
        const SizedBox(height: AppSpacing.sp1),
        Text(label,
            style: TextStyle(
                fontSize: AppTypography.fontSizeXs, color: mutedColor),
            textAlign: TextAlign.center),
      ]),
    );
  }
}
