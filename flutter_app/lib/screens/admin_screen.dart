import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/constants/app_constants.dart';
import '../models/content_model.dart';
import '../providers/auth_provider.dart';
import '../widgets/admin/admin_panel.dart';

/// Admin screen with role-based access control
class AdminScreen extends ConsumerWidget {
  const AdminScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);
    final isAdmin = authState.user?.isAdmin ?? false;

    // Loading state
    if (authState.isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    // Access denied
    if (!isAdmin) {
      return Scaffold(
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.sp4),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 400),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sp6),
                      decoration: BoxDecoration(
                        color: AppColors.likeRed.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.likeRed.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.shield_outlined,
                            size: 48,
                            color: AppColors.likeRed,
                          ),
                          const SizedBox(height: AppSpacing.sp4),
                          Text(
                            'Access Denied',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeXl,
                              fontWeight: AppTypography.fontWeightBold,
                              color: theme.colorScheme.onBackground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp2),
                          Text(
                            'You do not have permission to access this page. Only administrators can create and manage content ideas.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeSm,
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.lightMutedForeground,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp6),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pushReplacementNamed('/'),
                              child: const Text('Go Home'),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sp6),
                    
                    // Demo Info
                    Container(
                      padding: const EdgeInsets.all(AppSpacing.sp4),
                      decoration: BoxDecoration(
                        color: AppColors.infoBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppRadius.lg),
                        border: Border.all(
                          color: AppColors.infoBlue.withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Demo Information',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeXs,
                              fontWeight: AppTypography.fontWeightMedium,
                              color: AppColors.infoBlue,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sp2),
                          Text(
                            'To test the admin features, log in with the admin account credentials shown on the login page.',
                            style: TextStyle(
                              fontSize: AppTypography.fontSizeXs,
                              color: theme.brightness == Brightness.dark
                                  ? AppColors.darkMutedForeground
                                  : AppColors.lightMutedForeground,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    }

    // Admin access granted
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
              'Admin',
              style: TextStyle(
                fontSize: AppTypography.fontSize2xl,
                fontWeight: AppTypography.fontWeightBold,
              ),
            ),
          ),

          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            sliver: SliverToBoxAdapter(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: const AdminPanel(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
