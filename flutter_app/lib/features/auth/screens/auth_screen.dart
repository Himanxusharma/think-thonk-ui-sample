import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../controllers/auth_controller.dart';
import '../../shared/widgets/shared_widgets.dart';

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isLogin = true;
  bool _showPassword = false;
  bool _isLoading = false;
  String? _error;
  String? _success;

  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _handleSubmit() async {
    setState(() {
      _error = null;
      _success = null;
      _isLoading = true;
    });

    if (_isLogin) {
      final ok = await ref
          .read(authControllerProvider.notifier)
          .login(_emailController.text, _passwordController.text);
      if (ok && mounted) {
        setState(() => _success = 'Login successful! Redirecting...');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) Navigator.of(context).pushReplacementNamed('/');
      } else if (mounted) {
        setState(() {
          _error = ref.read(authControllerProvider).error ?? 'Login failed';
          _isLoading = false;
        });
      }
    } else {
      if (_nameController.text.isEmpty ||
          _emailController.text.isEmpty ||
          _passwordController.text.isEmpty) {
        setState(() {
          _error = 'Please fill in all fields';
          _isLoading = false;
        });
        return;
      }
      final ok = await ref.read(authControllerProvider.notifier).register(
            _emailController.text,
            _passwordController.text,
            _nameController.text,
          );
      if (ok && mounted) {
        setState(() => _success = 'Account created! Switching to login...');
        await Future.delayed(const Duration(milliseconds: 1500));
        if (mounted) {
          setState(() {
            _isLogin = true;
            _emailController.clear();
            _passwordController.clear();
            _nameController.clear();
            _isLoading = false;
            _success = null;
          });
        }
      } else if (mounted) {
        setState(() {
          _error =
              ref.read(authControllerProvider).error ?? 'Registration failed';
          _isLoading = false;
        });
      }
    }
  }

  void _toggleMode() {
    setState(() {
      _isLogin = !_isLogin;
      _error = null;
      _success = null;
      _emailController.clear();
      _passwordController.clear();
      _nameController.clear();
    });
  }

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
    final creds =
        ref.read(authControllerProvider.notifier).testCredentials;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.sp4),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 448),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    alignment: Alignment.center,
                    child: Text('TT',
                        style: TextStyle(
                          fontSize: AppTypography.fontSizeLg,
                          fontWeight: AppTypography.fontWeightBold,
                          color: theme.colorScheme.primary,
                        )),
                  ),
                  const SizedBox(height: AppSpacing.sp4),
                  Text('Think Thonk',
                      style: TextStyle(
                        fontSize: AppTypography.fontSize3xl,
                        fontWeight: AppTypography.fontWeightBold,
                        color: theme.colorScheme.onSurface,
                      )),
                  const SizedBox(height: AppSpacing.sp2),
                  Text(_isLogin ? 'Welcome back' : 'Join our community',
                      style: TextStyle(
                          fontSize: AppTypography.fontSizeSm,
                          color: mutedColor)),
                  const SizedBox(height: AppSpacing.sp8),

                  // Form card
                  Container(
                    padding: const EdgeInsets.all(AppSpacing.sp6),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                      border: Border.all(color: borderColor),
                    ),
                    child: Column(
                      children: [
                        if (!_isLogin) ...[
                          AppInput(
                            controller: _nameController,
                            label: 'Full Name',
                            placeholder: 'Enter your full name',
                            prefixIcon: Icons.person_outline,
                          ),
                          const SizedBox(height: AppSpacing.sp4),
                        ],
                        AppInput(
                          controller: _emailController,
                          label: 'Email',
                          placeholder: 'demo@thinkthonk.com',
                          prefixIcon: Icons.mail_outline,
                          keyboardType: TextInputType.emailAddress,
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        AppInput(
                          controller: _passwordController,
                          label: 'Password',
                          placeholder: 'Demo123!@#',
                          prefixIcon: Icons.lock_outline,
                          obscureText: !_showPassword,
                          suffix: IconButton(
                            onPressed: () => setState(
                                () => _showPassword = !_showPassword),
                            icon: Icon(
                              _showPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              size: 20,
                              color: mutedColor,
                            ),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sp4),
                        if (_error != null) ...[
                          _AlertBox(_error!, AppColors.likeRed),
                          const SizedBox(height: AppSpacing.sp4),
                        ],
                        if (_success != null) ...[
                          _AlertBox(_success!, AppColors.successGreen),
                          const SizedBox(height: AppSpacing.sp4),
                        ],
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSubmit,
                            style: ElevatedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(
                                    vertical: AppSpacing.sp3)),
                            child: Text(_isLoading
                                ? 'Loading...'
                                : _isLogin
                                    ? 'Sign In'
                                    : 'Create Account'),
                          ),
                        ),
                        const SizedBox(height: AppSpacing.sp6),
                        Row(children: [
                          Expanded(child: Divider(color: borderColor)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.sp2),
                            child: Text('or',
                                style: TextStyle(
                                    fontSize: AppTypography.fontSizeSm,
                                    color: mutedColor)),
                          ),
                          Expanded(child: Divider(color: borderColor)),
                        ]),
                        const SizedBox(height: AppSpacing.sp6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              _isLogin
                                  ? "Don't have an account? "
                                  : 'Already have an account? ',
                              style: TextStyle(
                                  fontSize: AppTypography.fontSizeSm,
                                  color: mutedColor),
                            ),
                            GestureDetector(
                              onTap: _toggleMode,
                              child: Text(
                                _isLogin ? 'Sign Up' : 'Sign In',
                                style: TextStyle(
                                  fontSize: AppTypography.fontSizeSm,
                                  fontWeight: AppTypography.fontWeightMedium,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sp6),

                  // Test credentials
                  _CredentialBox('Admin Account:', creds['admin']!.email,
                      creds['admin']!.password, AppColors.infoBlue),
                  const SizedBox(height: AppSpacing.sp3),
                  _CredentialBox('User Account:', creds['user']!.email,
                      creds['user']!.password, mutedColor),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _AlertBox extends StatelessWidget {
  final String message;
  final Color color;
  const _AlertBox(this.message, this.color);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sp3),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(message,
          style: TextStyle(
              fontSize: AppTypography.fontSizeSm, color: color)),
    );
  }
}

class _CredentialBox extends StatelessWidget {
  final String title;
  final String email;
  final String password;
  final Color accentColor;
  const _CredentialBox(this.title, this.email, this.password, this.accentColor);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mutedColor = theme.brightness == Brightness.dark
        ? AppColors.darkMutedForeground
        : AppColors.lightMutedForeground;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.sp4),
      decoration: BoxDecoration(
        color: accentColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: accentColor.withOpacity(0.2)),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: TextStyle(
                fontSize: AppTypography.fontSizeXs,
                fontWeight: AppTypography.fontWeightSemibold,
                color: theme.colorScheme.onSurface)),
        const SizedBox(height: AppSpacing.sp2),
        Text('Email: $email',
            style: TextStyle(
                fontSize: AppTypography.fontSizeXs,
                fontFamily: 'monospace',
                color: mutedColor)),
        Text('Password: $password',
            style: TextStyle(
                fontSize: AppTypography.fontSizeXs,
                fontFamily: 'monospace',
                color: mutedColor)),
      ]),
    );
  }
}
