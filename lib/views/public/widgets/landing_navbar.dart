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
    final isMobile = screenWidth < 600;

    return Container(
      height: isMobile ? 64 : 80,
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
            padding: EdgeInsets.symmetric(horizontal: isMobile ? 16.0 : 24.0),
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
                        width: isMobile ? 32 : 36,
                        height: isMobile ? 32 : 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [AppColors.brand700, AppColors.brand300],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight,
                          ),
                          borderRadius: BorderRadius.circular(
                            isMobile ? 8 : 10,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: AppColors.glowColor,
                              blurRadius: 15,
                              spreadRadius: 0,
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'L',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isMobile ? 18 : 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isMobile ? 8 : 10),
                      Text(
                        'LinguaNova',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 16 : 20,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                          shadows: const [
                            Shadow(color: Color(0x40FFFFFF), blurRadius: 20),
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
                      _navLink('Home', () => onNavigateSection('hero')),
                      _navLink('Features', () => onNavigateSection('features')),
                      _navLink(
                        'Languages',
                        () => onNavigateSection('languages'),
                      ),
                      _navLink('Pricing', () => onNavigateSection('pricing')),
                      _navLink(
                        'Community',
                        () => onNavigateSection('community'),
                      ),
                    ],
                  ),

                // Auth / Dashboard actions
                Row(
                  children: [
                    if (isMobile)
                      IconButton(
                        onPressed: () => _showMobileMenu(context),
                        tooltip: 'Open navigation menu',
                        icon: const Icon(Icons.menu, color: Colors.white),
                      )
                    else if (!isLoggedIn) ...[
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
                      SizedBox(width: isMobile ? 8 : 12),
                      GlassButton(
                        onPressed: onNavigateAuth,
                        variant: GlassButtonVariant.primary,
                        isLarge: false,
                        child: Text(isMobile ? 'Start' : 'Get Started'),
                      ),
                    ] else ...[
                      GlassButton(
                        onPressed: onNavigateAuth,
                        variant: GlassButtonVariant.primary,
                        isLarge: false,
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

  void _showMobileMenu(BuildContext context) {
    showGeneralDialog<void>(
      context: context,
      barrierLabel: 'Navigation menu',
      barrierDismissible: true,
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 250),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerRight,
          child: Drawer(
            width: MediaQuery.sizeOf(context).width * 0.82,
            backgroundColor: AppColors.dark900,
            child: SafeArea(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 8, 16, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Navigation',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          tooltip: 'Close navigation menu',
                          icon: const Icon(Icons.close, color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                  _mobileNavItem(context, 'Home', 'hero'),
                  _mobileNavItem(context, 'Features', 'features'),
                  _mobileNavItem(context, 'Languages', 'languages'),
                  _mobileNavItem(context, 'Pricing', 'pricing'),
                  _mobileNavItem(context, 'Community', 'community'),
                  const Divider(color: Color(0x26FFFFFF), height: 32),
                  if (!isLoggedIn) ...[
                    _mobileActionItem(
                      context,
                      label: 'Login',
                      onTap: onNavigateAuth,
                    ),
                    _mobileActionItem(
                      context,
                      label: 'Get Started',
                      onTap: onNavigateAuth,
                      isPrimary: true,
                    ),
                  ] else
                    _mobileActionItem(
                      context,
                      label: 'Dashboard',
                      onTap: onNavigateAuth,
                      isPrimary: true,
                    ),
                ],
              ),
            ),
          ),
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }

  Widget _mobileNavItem(BuildContext context, String label, String section) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        label,
        style: const TextStyle(color: AppColors.textMain, fontSize: 15),
      ),
      onTap: () {
        Navigator.pop(context);
        onNavigateSection(section);
      },
    );
  }

  Widget _mobileActionItem(
    BuildContext context, {
    required String label,
    required VoidCallback onTap,
    bool isPrimary = false,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 24),
      title: Text(
        label,
        style: TextStyle(
          color: isPrimary ? Colors.white : AppColors.textMain,
          fontSize: 15,
          fontWeight: isPrimary ? FontWeight.w600 : FontWeight.w500,
        ),
      ),
      tileColor: isPrimary ? AppColors.brand700 : null,
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
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
