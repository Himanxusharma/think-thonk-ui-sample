import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../auth/controllers/auth_controller.dart';

/// Profile menu dropdown
class ProfileMenu extends ConsumerStatefulWidget {
  const ProfileMenu({super.key});

  @override
  ConsumerState<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<ProfileMenu> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlay;
  bool _isOpen = false;

  void _toggle() => _isOpen ? _close() : _open();

  void _open() {
    final button =
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final overlay = Overlay.of(context).context.findRenderObject() as RenderBox;
    final pos = button.localToGlobal(Offset.zero, ancestor: overlay);

    _overlay = OverlayEntry(
      builder: (_) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
                onTap: _close,
                child: Container(color: Colors.transparent)),
          ),
          Positioned(
            right: overlay.size.width - pos.dx - button.size.width,
            top: pos.dy + button.size.height + 12,
            child: _MenuContent(
              isAdmin:
                  ref.read(authControllerProvider).user?.isAdmin ?? false,
              onNavigate: (route) {
                _close();
                Navigator.of(context).pushNamed(route);
              },
              onLogout: () async {
                _close();
                await ref.read(authControllerProvider.notifier).logout();
                if (mounted) {
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil('/auth', (_) => false);
                }
              },
            ),
          ),
        ],
      ),
    );
    Overlay.of(context).insert(_overlay!);
    setState(() => _isOpen = true);
  }

  void _close() {
    _overlay?.remove();
    _overlay = null;
    if (mounted) setState(() => _isOpen = false);
  }

  @override
  void dispose() {
    _close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        key: _buttonKey,
        onTap: _toggle,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sp2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: _isOpen ? mutedBg : Colors.transparent,
          ),
          child: Icon(Icons.person_outline,
              size: 20, color: theme.colorScheme.onSurface),
        ),
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  final bool isAdmin;
  final Function(String) onNavigate;
  final VoidCallback onLogout;

  const _MenuContent(
      {required this.isAdmin,
      required this.onNavigate,
      required this.onLogout});

  @override
  Widget build(BuildContext context) {
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
        ? AppColors.darkMuted.withOpacity(0.3)
        : AppColors.lightMuted.withOpacity(0.3);

    final items = [
      _Item(Icons.person_outline, 'Profile', '/profile'),
      _Item(Icons.bookmark_outline, 'Saved Articles', '/saved'),
      _Item(Icons.settings_outlined, 'Settings', '/settings'),
      if (isAdmin) _Item(Icons.flash_on, 'Admin Dashboard', '/admin', true),
    ];

    return Material(
      color: Colors.transparent,
      child: Container(
        width: 224,
        decoration: BoxDecoration(
          color: cardColor,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          border: Border.all(color: borderColor),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp4, vertical: AppSpacing.sp3),
              decoration: BoxDecoration(
                color: mutedBg,
                border: Border(bottom: BorderSide(color: borderColor)),
                borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(AppRadius.lg)),
              ),
              child: Text('ACCOUNT',
                  style: TextStyle(
                      fontSize: AppTypography.fontSizeXs,
                      fontWeight: AppTypography.fontWeightSemibold,
                      color: mutedColor,
                      letterSpacing: 0.5)),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: AppSpacing.sp1),
              child: Column(
                children: items
                    .map((item) => _buildRow(context, item, theme,
                        mutedColor, borderColor))
                    .toList(),
              ),
            ),
            Divider(height: 1, color: borderColor),
            InkWell(
              onTap: onLogout,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sp4, vertical: AppSpacing.sp3),
                child: Row(
                  children: const [
                    Icon(Icons.logout, size: 16, color: AppColors.likeRed),
                    SizedBox(width: AppSpacing.sp3),
                    Text('Logout',
                        style: TextStyle(
                            fontSize: AppTypography.fontSizeSm,
                            color: AppColors.likeRed)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, _Item item, ThemeData theme,
      Color mutedColor, Color borderColor) {
    return Material(
      color: item.highlighted
          ? theme.colorScheme.primary.withOpacity(0.05)
          : Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(item.route),
        child: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sp4, vertical: AppSpacing.sp3),
          decoration: item.highlighted
              ? BoxDecoration(
                  border: Border(
                      left: BorderSide(
                          color: theme.colorScheme.primary, width: 2)))
              : null,
          child: Row(
            children: [
              Icon(item.icon, size: 16,
                  color: item.highlighted
                      ? theme.colorScheme.primary
                      : mutedColor),
              const SizedBox(width: AppSpacing.sp3),
              Expanded(
                child: Text(item.label,
                    style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        fontWeight: AppTypography.fontWeightMedium,
                        color: item.highlighted
                            ? theme.colorScheme.primary
                            : theme.colorScheme.onSurface)),
              ),
              Icon(Icons.chevron_right,
                  size: 16, color: mutedColor.withOpacity(0.5)),
            ],
          ),
        ),
      ),
    );
  }
}

class _Item {
  final IconData icon;
  final String label;
  final String route;
  final bool highlighted;
  const _Item(this.icon, this.label, this.route, [this.highlighted = false]);
}
