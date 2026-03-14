import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../providers/auth_provider.dart';

/// Profile menu dropdown widget
class ProfileMenu extends ConsumerStatefulWidget {
  const ProfileMenu({super.key});

  @override
  ConsumerState<ProfileMenu> createState() => _ProfileMenuState();
}

class _ProfileMenuState extends ConsumerState<ProfileMenu> {
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  void _toggleMenu() {
    if (_isOpen) {
      _closeMenu();
    } else {
      _openMenu();
    }
  }

  void _openMenu() {
    final RenderBox button = 
        _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final RenderBox overlay = 
        Overlay.of(context).context.findRenderObject() as RenderBox;
    final Offset position = button.localToGlobal(Offset.zero, ancestor: overlay);

    _overlayEntry = OverlayEntry(
      builder: (context) => Stack(
        children: [
          // Backdrop
          Positioned.fill(
            child: GestureDetector(
              onTap: _closeMenu,
              child: Container(color: Colors.transparent),
            ),
          ),
          // Menu
          Positioned(
            right: overlay.size.width - position.dx - button.size.width,
            top: position.dy + button.size.height + 12,
            child: _MenuContent(
              onClose: _closeMenu,
              onNavigate: _handleNavigate,
              onLogout: _handleLogout,
              isAdmin: ref.read(authProvider).user?.isAdmin ?? false,
            ),
          ),
        ],
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
    setState(() => _isOpen = true);
  }

  void _closeMenu() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    setState(() => _isOpen = false);
  }

  void _handleNavigate(String route) {
    _closeMenu();
    Navigator.of(context).pushNamed(route);
  }

  void _handleLogout() async {
    _closeMenu();
    await ref.read(authProvider.notifier).logout();
    if (mounted) {
      Navigator.of(context).pushNamedAndRemoveUntil('/auth', (route) => false);
    }
  }

  @override
  void dispose() {
    _closeMenu();
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
        onTap: _toggleMenu,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        child: Container(
          padding: const EdgeInsets.all(AppSpacing.sp2),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            color: _isOpen ? mutedBg : Colors.transparent,
          ),
          child: Icon(
            Icons.person_outline,
            size: 20,
            color: theme.colorScheme.onBackground,
          ),
        ),
      ),
    );
  }
}

class _MenuContent extends StatelessWidget {
  final VoidCallback onClose;
  final Function(String) onNavigate;
  final VoidCallback onLogout;
  final bool isAdmin;

  const _MenuContent({
    required this.onClose,
    required this.onNavigate,
    required this.onLogout,
    required this.isAdmin,
  });

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

    final menuItems = [
      _MenuItem(icon: Icons.person_outline, label: 'Profile', route: '/profile'),
      _MenuItem(icon: Icons.bookmark_outline, label: 'Saved Articles', route: '/saved'),
      _MenuItem(icon: Icons.settings_outlined, label: 'Settings', route: '/settings'),
      if (isAdmin)
        _MenuItem(
          icon: Icons.flash_on,
          label: 'Admin Dashboard',
          route: '/admin',
          isHighlighted: true,
        ),
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
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.sp4,
                vertical: AppSpacing.sp3,
              ),
              decoration: BoxDecoration(
                color: mutedBg,
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(AppRadius.lg),
                ),
              ),
              child: Text(
                'ACCOUNT',
                style: TextStyle(
                  fontSize: AppTypography.fontSizeXs,
                  fontWeight: AppTypography.fontWeightSemibold,
                  color: mutedColor,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            
            // Menu Items
            Padding(
              padding: const EdgeInsets.symmetric(vertical: AppSpacing.sp1),
              child: Column(
                children: menuItems.map((item) => _buildMenuItem(
                  context,
                  item,
                  onNavigate,
                )).toList(),
              ),
            ),
            
            // Divider
            Divider(height: 1, color: borderColor),
            
            // Logout
            InkWell(
              onTap: onLogout,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sp4,
                  vertical: AppSpacing.sp3,
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.logout,
                      size: 16,
                      color: AppColors.likeRed,
                    ),
                    const SizedBox(width: AppSpacing.sp3),
                    const Text(
                      'Logout',
                      style: TextStyle(
                        fontSize: AppTypography.fontSizeSm,
                        color: AppColors.likeRed,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(
    BuildContext context,
    _MenuItem item,
    Function(String) onNavigate,
  ) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;
    final mutedBg = theme.brightness == Brightness.dark
        ? AppColors.darkMuted
        : AppColors.lightMuted;

    return Material(
      color: item.isHighlighted 
          ? theme.colorScheme.primary.withOpacity(0.05) 
          : Colors.transparent,
      child: InkWell(
        onTap: () => onNavigate(item.route),
        child: Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sp4,
            vertical: AppSpacing.sp3,
          ),
          decoration: item.isHighlighted
              ? BoxDecoration(
                  border: Border(
                    left: BorderSide(
                      color: theme.colorScheme.primary,
                      width: 2,
                    ),
                  ),
                )
              : null,
          child: Row(
            children: [
              Icon(
                item.icon,
                size: 16,
                color: item.isHighlighted 
                    ? theme.colorScheme.primary 
                    : mutedColor,
              ),
              const SizedBox(width: AppSpacing.sp3),
              Expanded(
                child: Text(
                  item.label,
                  style: TextStyle(
                    fontSize: AppTypography.fontSizeSm,
                    fontWeight: AppTypography.fontWeightMedium,
                    color: item.isHighlighted 
                        ? theme.colorScheme.primary 
                        : theme.colorScheme.onBackground,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right,
                size: 16,
                color: mutedColor.withOpacity(0.5),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  final bool isHighlighted;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.route,
    this.isHighlighted = false,
  });
}
