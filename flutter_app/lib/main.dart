import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/theme/app_theme.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/saved_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/admin_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Set preferred orientations
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  runApp(
    const ProviderScope(
      child: ThinkThonkApp(),
    ),
  );
}

class ThinkThonkApp extends ConsumerWidget {
  const ThinkThonkApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeState = ref.watch(themeProvider);

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
      },
      builder: (context, child) {
        // Apply global styles
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

/// Custom scroll behavior to hide scrollbars globally
class _NoScrollbarBehavior extends ScrollBehavior {
  @override
  Widget buildScrollbar(
    BuildContext context,
    Widget child,
    ScrollableDetails details,
  ) {
    return child;
  }
}
