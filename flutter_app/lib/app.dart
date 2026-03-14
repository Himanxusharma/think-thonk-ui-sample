import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'features/auth/controllers/auth_controller.dart';
import 'features/auth/screens/auth_screen.dart';
import 'features/auth/screens/profile_screen.dart';
import 'features/feed/screens/home_screen.dart';
import 'features/saved/screens/saved_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'features/admin/screens/admin_screen.dart';

import 'features/categories/screens/categories_screen.dart';

/// App router and shell
class ThinkThonkApp extends ConsumerWidget {
  const ThinkThonkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeControllerProvider);

    return MaterialApp(
      title: 'Think Thonk',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: themeState.effectiveTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        '/auth': (context) => const AuthScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/saved': (context) => const SavedScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/admin': (context) => const AdminScreen(),
        '/categories': (context) => const CategoriesScreen(),
      },
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: TextScaler.noScaling,
          ),
          child: ScrollConfiguration(
            behavior: _NoScrollbarBehavior(),
            child: child!,
          ),
        );
      },
    );
  }
}

class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
      BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}
