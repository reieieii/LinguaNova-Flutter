import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';

class DashboardLayout extends StatefulWidget {
  const DashboardLayout({
    super.key,
    required this.child,
    required this.currentRoute,
  });

  final Widget child;
  final String currentRoute;

  @override
  State<DashboardLayout> createState() => _DashboardLayoutState();
}

class _DashboardLayoutState extends State<DashboardLayout> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchController = TextEditingController();

  static const List<_NavItem> _navItems = [
    _NavItem(label: 'Dashboard', icon: Icons.grid_view_rounded, route: '/dashboard'),
    _NavItem(label: 'Practice', icon: Icons.sports_esports_rounded, route: '/practice'),
    _NavItem(label: 'Languages', icon: Icons.translate_rounded, route: '/languages'),
    _NavItem(label: 'Vocabulary', icon: Icons.auto_stories_rounded, route: '/vocabulary'),
    _NavItem(label: 'Achievements', icon: Icons.workspace_premium_rounded, route: '/achievements'),
    _NavItem(label: 'Progress', icon: Icons.insights_rounded, route: '/progress'),
    _NavItem(label: 'Calendar', icon: Icons.calendar_month_rounded, route: '/calendar'),
    _NavItem(label: 'Settings', icon: Icons.settings_rounded, route: '/settings'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isDesktop = screenWidth > 900;
    final state = context.watch<AppState>();
    final user = state.currentUser;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.dark900,
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: AppColors.dark900,
              child: _buildSidebarContent(context, state, user, isDrawer: true),
            ),
      body: Row(
        children: [
          if (isDesktop)
            SizedBox(
              width: 260,
              child: _buildSidebarContent(context, state, user),
            ),
          Expanded(
            child: Column(
              children: [
                _buildTopHeader(context, isDesktop, user, state),
                Expanded(child: widget.child),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(
    BuildContext context,
    bool isDesktop,
    dynamic user,
    AppState state,
  ) {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        color: Color(0x99120018),
        border: Border(bottom: BorderSide(color: Color(0x0DFFFFFF))),
      ),
      child: Row(
        children: [
          if (!isDesktop)
            IconButton(
              icon: const Icon(Icons.menu_rounded, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState?.openDrawer(),
            ),

          // Search Bar
          Expanded(
            child: Container(
              height: 40,
              constraints: const BoxConstraints(maxWidth: 400),
              child: TextField(
                controller: _searchController,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search courses, vocabulary...',
                  hintStyle: TextStyle(color: Colors.white.withValues(alpha: 0.35), fontSize: 13),
                  prefixIcon: Icon(Icons.search_rounded, color: Colors.white.withValues(alpha: 0.35), size: 18),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: AppColors.brand500),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Streak Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('🔥', style: TextStyle(fontSize: 13)),
                const SizedBox(width: 5),
                Text(
                  '${state.streak.count} Days',
                  style: const TextStyle(
                    color: Colors.orange,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // Notification Bell
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
                ),
                child: const Icon(Icons.notifications_outlined, color: Colors.white70, size: 19),
              ),
              Positioned(
                top: 4,
                right: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: AppColors.brand500,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 10),

          // User Profile Avatar
          InkWell(
            onTap: () => context.go('/profile'),
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
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.brand500.withValues(alpha: 0.35),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ),
                ),
                if (isDesktop) ...[
                  const SizedBox(width: 8),
                  Text(
                    user?.name ?? 'User',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Logout
          IconButton(
            icon: const Icon(Icons.logout_rounded, color: AppColors.textMuted, size: 18),
            tooltip: 'Log out',
            onPressed: () {
              state.signOut();
              context.go('/');
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarContent(
    BuildContext context,
    AppState state,
    dynamic user, {
    bool isDrawer = false,
  }) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xB3120018),
        border: Border(right: BorderSide(color: Color(0x0DFFFFFF))),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Brand Logo
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
              child: InkWell(
                onTap: () => context.go('/dashboard'),
                borderRadius: BorderRadius.circular(12),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [AppColors.brand700, AppColors.brand300],
                        ),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(color: AppColors.glowColor, blurRadius: 14),
                        ],
                      ),
                      child: const Center(
                        child: Text(
                          'L',
                          style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'LunaVerse',
                      style: TextStyle(color: Colors.white, fontSize: 19, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(color: Color(0x0DFFFFFF), height: 1),

            // Profile Card
            _buildProfileCard(state, user),

            const Divider(color: Color(0x0DFFFFFF), height: 1),
            const SizedBox(height: 10),

            // Nav Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: _navItems.map((item) {
                  final isActive = widget.currentRoute == item.route;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 3.0),
                    child: InkWell(
                      onTap: () {
                        if (isDrawer) Navigator.pop(context);
                        context.go(item.route);
                      },
                      borderRadius: BorderRadius.circular(11),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        decoration: BoxDecoration(
                          color: isActive
                              ? AppColors.brand500.withValues(alpha: 0.15)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(11),
                          border: isActive
                              ? Border.all(color: AppColors.brand500.withValues(alpha: 0.3))
                              : null,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              item.icon,
                              size: 18,
                              color: isActive ? AppColors.brand300 : AppColors.textMuted,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              item.label,
                              style: TextStyle(
                                color: isActive ? Colors.white : AppColors.textMuted,
                                fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileCard(AppState state, dynamic user) {
    const int level = 12;
    const int xp = 4250;
    const int maxXp = 5000;
    const double xpProgress = xp / maxXp;

    return Container(
      margin: const EdgeInsets.all(14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.brand900.withValues(alpha: 0.8),
            AppColors.brand700.withValues(alpha: 0.3),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.brand500.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Avatar circle
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.brand700, AppColors.brand300],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(11),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.brand500.withValues(alpha: 0.35),
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    (user?.name ?? 'U').substring(0, 1).toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.name ?? 'Learner',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 3),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: AppColors.brand500.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: const Text(
                            'Lv $level',
                            style: TextStyle(
                              color: AppColors.brand300,
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '$xp XP',
                          style: TextStyle(color: AppColors.textMuted, fontSize: 10),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // XP Progress Bar
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'XP to next level',
                    style: TextStyle(color: Colors.white.withValues(alpha: 0.45), fontSize: 9),
                  ),
                  const Text(
                    '$xp / $maxXp',
                    style: TextStyle(color: AppColors.brand300, fontSize: 9, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: const LinearProgressIndicator(
                  value: xpProgress,
                  minHeight: 5,
                  backgroundColor: Color(0x1AFFFFFF),
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.brand500),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Streak & Coins
          Row(
            children: [
              _buildMiniStat('🔥', '${state.streak.count}d', 'Streak', Colors.orange),
              const SizedBox(width: 6),
              _buildMiniStat('🪙', '320', 'Coins', Colors.amber),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStat(String emoji, String value, String label, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 11)),
            const SizedBox(width: 4),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    value,
                    style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                  Text(
                    label,
                    style: TextStyle(color: color.withValues(alpha: 0.55), fontSize: 8),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.label,
    required this.icon,
    required this.route,
  });

  final String label;
  final IconData icon;
  final String route;
}
