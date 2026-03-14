import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import '../core/constants/app_constants.dart';
import '../providers/content_provider.dart';
import '../providers/theme_provider.dart';
import '../widgets/content_card.dart';
import '../widgets/expanded_modal.dart';
import '../widgets/fullscreen_content.dart';
import '../widgets/profile_menu.dart';

/// Home screen with content feed
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
    final currentPosition = _pageController.position.pixels;
    final delta = currentPosition - _lastScrollPosition;
    
    if (delta > 10 && _showTopBar) {
      setState(() => _showTopBar = false);
    } else if (delta < -10 && !_showTopBar) {
      setState(() => _showTopBar = true);
    }
    
    _lastScrollPosition = currentPosition;
  }

  Future<void> _handleShare(int id) async {
    final contentState = ref.read(contentProvider);
    final item = contentState.content.firstWhere((c) => c.id == id);
    
    try {
      await Share.share(
        '${item.headline}\n\n${item.content}',
        subject: item.headline,
      );
      ref.read(contentProvider.notifier).markShared(id);
    } catch (e) {
      // Silently handle share errors
    }
  }

  @override
  Widget build(BuildContext context) {
    final contentState = ref.watch(contentProvider);
    final themeState = ref.watch(themeProvider);
    final theme = Theme.of(context);
    final borderColor = theme.brightness == Brightness.dark
        ? AppColors.darkBorder
        : AppColors.lightBorder;

    return Scaffold(
      body: Stack(
        children: [
          // Content Feed
          NotificationListener<ScrollNotification>(
            onNotification: (notification) {
              _handleScroll();
              return false;
            },
            child: PageView.builder(
              controller: _pageController,
              scrollDirection: Axis.vertical,
              itemCount: contentState.content.length,
              itemBuilder: (context, index) {
                final item = contentState.content[index];
                return ContentCard(
                  item: item,
                  onReadMore: () {
                    ref.read(contentProvider.notifier).openModal(item);
                  },
                  onSave: () {
                    ref.read(contentProvider.notifier).toggleSave(item.id);
                  },
                  onLike: () {
                    ref.read(contentProvider.notifier).toggleLike(item.id);
                  },
                  onShare: () => _handleShare(item.id),
                  onFullscreen: () {
                    ref.read(contentProvider.notifier).openFullscreen(index);
                  },
                );
              },
            ),
          ),
          
          // Top Navigation Bar
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
                border: Border(
                  bottom: BorderSide(color: borderColor),
                ),
              ),
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sp4),
              child: SafeArea(
                bottom: false,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Streak Display
                    Row(
                      children: [
                        const Icon(
                          Icons.local_fire_department,
                          color: AppColors.streakOrange,
                          size: 20,
                        ),
                        const SizedBox(width: AppSpacing.sp2),
                        Text(
                          contentState.streak.toString(),
                          style: TextStyle(
                            fontSize: AppTypography.fontSizeSm,
                            fontWeight: AppTypography.fontWeightSemibold,
                            color: theme.colorScheme.onBackground,
                          ),
                        ),
                      ],
                    ),
                    
                    // Right Side Controls
                    Row(
                      children: [
                        // Theme Toggle
                        IconButton(
                          onPressed: () {
                            ref.read(themeProvider.notifier).toggleTheme();
                          },
                          icon: Icon(
                            themeState.mode == AppThemeMode.dark
                                ? Icons.light_mode
                                : Icons.dark_mode,
                            size: 20,
                          ),
                        ),
                        // Profile Menu
                        const ProfileMenu(),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          
          // Expanded Modal
          if (contentState.isModalOpen && contentState.selectedContent != null)
            ExpandedModal(
              content: contentState.selectedContent!,
              onClose: () {
                ref.read(contentProvider.notifier).closeModal();
              },
            ),
          
          // Fullscreen Content
          if (contentState.isFullscreenOpen)
            FullscreenContent(
              content: contentState.content,
              initialIndex: contentState.fullscreenIndex,
              streak: contentState.streak,
              onClose: () {
                ref.read(contentProvider.notifier).closeFullscreen();
              },
              onSave: (id) {
                ref.read(contentProvider.notifier).toggleSave(id);
              },
              onLike: (id) {
                ref.read(contentProvider.notifier).toggleLike(id);
              },
              onShare: _handleShare,
            ),
        ],
      ),
    );
  }
}
