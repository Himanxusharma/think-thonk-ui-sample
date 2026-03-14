import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../features/auth/controllers/auth_controller.dart';
import '../../../features/streak/controllers/streak_controller.dart';
import '../controllers/feed_controller.dart';
import '../widgets/content_card.dart';
import '../widgets/expanded_modal.dart';
import '../widgets/fullscreen_content.dart';
import '../widgets/profile_menu.dart';
import '../../share/controllers/share_controller.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final PageController _pageController = PageController();
  double _lastScrollPosition = 0;
  bool _showTopBar = true;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _handleScroll() {
    final position = _pageController.position.pixels;
    final delta = position - _lastScrollPosition;
    if (delta > 10 && _showTopBar) {
      setState(() => _showTopBar = false);
    } else if (delta < -10 && !_showTopBar) {
      setState(() => _showTopBar = true);
    }
    _lastScrollPosition = position;
  }

  @override
  Widget build(BuildContext context) {
    final feedState = ref.watch(feedControllerProvider);
    final themeState = ref.watch(themeControllerProvider);
    final streakState = ref.watch(streakControllerProvider);
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      body: Stack(
        children: [
          // ── Content Feed ──────────────────────────────────────────────────
          NotificationListener<ScrollNotification>(
            onNotification: (_) {
              _handleScroll();
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: feedState.ideas.length,
              itemBuilder: (context, index) {
                final idea = feedState.ideas[index];
                return ContentCard(
                  idea: idea,
                  onReadMore: () =>
                      ref.read(feedControllerProvider.notifier).openModal(idea),
                  onSave: () =>
                      ref.read(feedControllerProvider.notifier).toggleSave(idea.id),
                  onLike: () {
                    ref.read(feedControllerProvider.notifier).toggleLike(idea.id);
                    if (!idea.liked) {
                      ref.read(streakControllerProvider.notifier).increment();
                    }
                  },
                  onShare: () =>
                      ref.read(shareControllerProvider).share(idea),
                  onFullscreen: () =>
                      ref.read(feedControllerProvider.notifier).openFullscreen(index),
                );
              },
            ),
          ),

          // ── Top Navigation Bar ────────────────────────────────────────────
          AnimatedPositioned(
            duration: AppAnimations.normal,
            curve: Curves.easeInOut,
            top: _showTopBar ? 0 : -AppUI.navbarHeight,
            left: 0,
            right: 0,
            child: Container(
              height: AppUI.navbarHeight,
              decoration: BoxDecoration(
                color: theme.scaffoldBackgroundColor,
                border: Border(bottom: BorderSide(color: borderColor)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp4),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Streak
                    Row(
                      children: [
                        const Icon(Icons.local_fire_department,
                            color: AppColors.streakOrange, size: 20),
                        const SizedBox(width: AppSpacing.sp2),
                        Text(
                          streakState.count.toString(),
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeSm,
                            fontWeight: AppTypography.fontWeightSemibold,
                            color: theme.colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                    // Right controls
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => ref
                              .read(themeControllerProvider.notifier)
                              .toggleTheme(),
                          icon: Icon(
                            themeState.mode == AppThemeMode.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            size: 20,
                          ),
                        ),
                        const ProfileMenu(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Expanded Modal ─────────────────────────────────────────────────
          if (feedState.isModalOpen && feedState.selectedIdea != null)
            ExpandedModal(
              idea: feedState.selectedIdea!,
              onClose: () =>
                  ref.read(feedControllerProvider.notifier).closeModal(),
            ),

          // ── Fullscreen Content ─────────────────────────────────────────────
          if (feedState.isFullscreenOpen)
            FullscreenContent(
              ideas: feedState.ideas,
              initialIndex: feedState.fullscreenIndex,
              streak: streakState.count,
              onClose: () =>
                  ref.read(feedControllerProvider.notifier).closeFullscreen(),
              onSave: (id) =>
                  ref.read(feedControllerProvider.notifier).toggleSave(id),
              onLike: (id) =>
                  ref.read(feedControllerProvider.notifier).toggleLike(id),
              onShare: (idea) =>
                  ref.read(shareControllerProvider).share(idea),
            ),
        ],
      ),
    );
  }
}
