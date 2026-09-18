import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';
import '../public/landing_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({super.key});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  bool registerMode = false;
  bool busy = false;
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool showWelcomeScreen = false;
  bool rememberMe = true;

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  // ── helpers ──────────────────────────────────────────────────────────────────

  void _showSnackBar(String message, {bool isError = false}) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline_rounded : Icons.check_circle_outline_rounded,
              color: Colors.white,
              size: 20,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                message,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFB91C1C) : const Color(0xFF15803D),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: Duration(seconds: isError ? 5 : 4),
      ),
    );
  }

  void _showEmailConfirmationDialog() {
    if (!mounted) return;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.dark800,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('📧', style: TextStyle(fontSize: 24)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Konfirmasi Email',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: const Text(
          'Akun Anda berhasil dibuat!\n\n'
          'Kami telah mengirimkan email konfirmasi ke alamat email yang Anda daftarkan. '
          'Silakan cek kotak masuk (atau folder spam) dan klik link konfirmasi sebelum login.',
          style: TextStyle(color: AppColors.textMuted, fontSize: 14, height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              // Switch to login mode so user can sign in after confirming
              setState(() => registerMode = false);
            },
            child: const Text(
              'Mengerti, ke halaman Login',
              style: TextStyle(color: AppColors.brand300, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── main submit ───────────────────────────────────────────────────────────────

  Future<void> submit() async {
    // Basic client-side validation
    final email = emailController.text.trim();
    final password = passwordController.text;
    final name = nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      _showSnackBar('Email dan password tidak boleh kosong.', isError: true);
      return;
    }
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showSnackBar('Format email tidak valid.', isError: true);
      return;
    }
    if (password.length < 6) {
      _showSnackBar('Password minimal 6 karakter.', isError: true);
      return;
    }
    if (registerMode) {
      if (name.isEmpty) {
        _showSnackBar('Nama lengkap tidak boleh kosong.', isError: true);
        return;
      }
      final confirm = confirmPasswordController.text;
      if (password != confirm) {
        _showSnackBar('Password dan konfirmasi password tidak cocok.', isError: true);
        return;
      }
    }

    setState(() => busy = true);

    final appState = context.read<AppState>();

    if (registerMode) {
      // ── REGISTER ────────────────────────────────────────────────────────────
      final success = await appState.register(name, email, password);

      if (!mounted) return;
      setState(() => busy = false);

      if (!success && appState.registrationMessage != null) {
        // Email confirmation required — show dialog
        _showEmailConfirmationDialog();
        return;
      }
      if (!success && appState.errorMessage != null) {
        // Hard error (duplicate email, weak password, network, etc.)
        _showSnackBar(appState.errorMessage!, isError: true);
        return;
      }
      if (success) {
        // Supabase confirmed immediately (e-mail confirmation disabled in project)
        _showSnackBar('Akun berhasil dibuat! Selamat datang 🎉');
        context.go('/dashboard');
      }
    } else {
      // ── LOGIN ────────────────────────────────────────────────────────────────
      final success = await appState.signIn(email, password);

      if (!mounted) return;
      setState(() => busy = false);

      if (!success) {
        _showSnackBar(
          appState.errorMessage ?? 'Login gagal. Periksa email dan password Anda.',
          isError: true,
        );
        return; // Block navigation — stay on login page
      }

      // Success — navigate to dashboard
      context.go('/dashboard');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (showWelcomeScreen) {
      return LandingPage(
        onNavigateToAuth: () => setState(() => showWelcomeScreen = false),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: Stack(
        children: [
          // Background Ambient Glow Orbs
          Positioned(
            top: -120,
            left: -120,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brand700.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -120,
            right: -120,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brand500.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Centered Responsive Layout
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Logo Header
                      InkWell(
                        onTap: () => context.go('/'),
                        borderRadius: BorderRadius.circular(16),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [AppColors.brand700, AppColors.brand300],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight,
                                ),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: const [
                                  BoxShadow(
                                    color: AppColors.glowColor,
                                    blurRadius: 18,
                                    spreadRadius: 0,
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  'L',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            const Text(
                              'LinguaNova',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                letterSpacing: -0.5,
                                shadows: [
                                  Shadow(
                                    color: Color(0x40FFFFFF),
                                    blurRadius: 20,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 32),

                      // Form Glass Card Container
                      GlassCard(
                        padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.sizeOf(context).width < 400 ? 18 : 32,
                          vertical: 32,
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                registerMode ? 'Create an Account' : 'Welcome Back',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                registerMode
                                    ? 'Start your language learning journey'
                                    : 'Continue your learning journey',
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 28),

                              // Name Field (Register Mode Only)
                              if (registerMode) ...[
                                _buildTextField(
                                  controller: nameController,
                                  label: 'Full Name',
                                  icon: Icons.person_outline_rounded,
                                ),
                                const SizedBox(height: 16),
                              ],

                              // Email Field
                              _buildTextField(
                                controller: emailController,
                                label: 'Email',
                                icon: Icons.email_outlined,
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 16),

                              // Password Field
                              _buildPasswordField(
                                controller: passwordController,
                                label: 'Password',
                                obscureText: obscurePassword,
                                onToggle: () => setState(() => obscurePassword = !obscurePassword),
                              ),

                              // Confirm Password Field (Register Mode Only)
                              if (registerMode) ...[
                                const SizedBox(height: 16),
                                _buildPasswordField(
                                  controller: confirmPasswordController,
                                  label: 'Confirm Password',
                                  obscureText: obscureConfirmPassword,
                                  onToggle: () => setState(() => obscureConfirmPassword = !obscureConfirmPassword),
                                ),
                              ],

                              // Remember Me & Forgot Password (Login Mode Only)
                              if (!registerMode) ...[
                                const SizedBox(height: 12),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: Checkbox(
                                            value: rememberMe,
                                            activeColor: AppColors.brand500,
                                            side: const BorderSide(color: AppColors.textMuted),
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            onChanged: (val) {
                                              if (val != null) setState(() => rememberMe = val);
                                            },
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Text(
                                          'Remember me',
                                          style: TextStyle(
                                            color: AppColors.textMuted,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ],
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(
                                            content: Text('Password reset instructions sent to email.'),
                                          ),
                                        );
                                      },
                                      child: const Text(
                                        'Forgot password?',
                                        style: TextStyle(
                                          color: AppColors.brand300,
                                          fontSize: 13,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                              const SizedBox(height: 28),

                              // Primary Submit Button
                              GlassButton(
                                onPressed: busy ? null : submit,
                                variant: GlassButtonVariant.primary,
                                isLarge: true,
                                fullWidth: true,
                                child: busy
                                    ? const SizedBox(
                                        width: 22,
                                        height: 22,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          color: Colors.white,
                                        ),
                                      )
                                    : Text(registerMode ? 'Register' : 'Log In'),
                              ),
                              const SizedBox(height: 16),

                              // Secondary Mode Toggle Button
                              GlassButton(
                                onPressed: () {
                                  setState(() => registerMode = !registerMode);
                                },
                                variant: GlassButtonVariant.glass,
                                isLarge: false,
                                fullWidth: true,
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4),
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      registerMode
                                          ? 'Already have an account? Log in'
                                          : 'Create an account',
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),

                              // Back to Home Link
                              TextButton(
                                onPressed: () => context.go('/'),
                                child: const Text(
                                  '← Back to Home',
                                  style: TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        prefixIcon: Icon(icon, color: Colors.white.withValues(alpha: 0.7), size: 20),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brand500, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }

  Widget _buildPasswordField({
    required TextEditingController controller,
    required String label,
    required bool obscureText,
    required VoidCallback onToggle,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.white.withValues(alpha: 0.7)),
        prefixIcon: Icon(Icons.lock_outline_rounded, color: Colors.white.withValues(alpha: 0.7), size: 20),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(
            obscureText ? Icons.visibility_outlined : Icons.visibility_off_outlined,
            color: Colors.white.withValues(alpha: 0.7),
            size: 20,
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.brand500, width: 2),
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.05),
      ),
    );
  }
}
