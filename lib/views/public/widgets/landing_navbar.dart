import 'dart:ui';
import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/glass_button.dart';

class LandingNavbar extends StatelessWidget implements PreferredSizeWidget {
  const LandingNavbar({
    super.key,
    required this.onNavigateAuth,
    required this.onNavigateSection,
    this.isLoggedIn = false,
  });

  final VoidCallback onNavigateAuth;
  final Function(String section) onNavigateSection;
  final bool isLoggedIn;

  @override
  Size get preferredSize => const Size.fromHeight(80);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 850;

    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Color(0x99120018), // bg-dark-900/60
        border: Border(
          bottom: BorderSide(
            color: Color(0x0DFFFFFF), // border-white/5
            width: 1,
          ),
        ),
      ),
      child: ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Brand Logo
                InkWell(
                  onTap: () => onNavigateSection('hero'),
                  borderRadius: BorderRadius.circular(12),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.brand700, AppColors.brand300],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.glowColor,
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: const Center(
                          child: Text(
                            'L',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'LinguaNova',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
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

                // Desktop Nav Items
                if (isDesktop)
                  Row(
                    children: [
                      _navLink('Features', () => onNavigateSection('features')),
                      _navLink('Languages', () => onNavigateSection('languages')),
                      _navLink('Pricing', () => onNavigateSection('pricing')),
                      _navLink('Community', () => onNavigateSection('community')),
                    ],
                  ),

                // Auth / Dashboard actions
                Row(
                  children: [
                    if (!isLoggedIn) ...[
                      if (isDesktop)
                        TextButton(
                          onPressed: onNavigateAuth,
                          child: const Text(
                            'Login',
                            style: TextStyle(
                              color: AppColors.textMain,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      const SizedBox(width: 12),
                      GlassButton(
                        onPressed: onNavigateAuth,
                        variant: GlassButtonVariant.primary,
                        child: const Text('Get Started'),
                      ),
                    ] else ...[
                      GlassButton(
                        onPressed: onNavigateAuth,
                        variant: GlassButtonVariant.primary,
                        child: const Text('Dashboard'),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _navLink(String label, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          child: Text(
            label,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
