import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class DashboardMainPage extends StatelessWidget {
  const DashboardMainPage({super.key});

  static const List<Map<String, dynamic>> _allLanguages = [
    {
      'id': 'japanese',
      'name': 'Japanese',
      'flag': '🇯🇵',
      'themeColor': Color(0xFFEF4444),
      'level': 'Intermediate',
      'progress': 65,
      'xp': 1420,
    },
    {
      'id': 'chinese',
      'name': 'Chinese',
      'flag': '🇨🇳',
      'themeColor': Color(0xFFF59E0B),
      'level': 'Beginner',
      'progress': 30,
      'xp': 640,
    },
    {
      'id': 'korean',
      'name': 'Korean',
      'flag': '🇰🇷',
      'themeColor': Color(0xFF3B82F6),
      'level': 'Beginner',
      'progress': 15,
      'xp': 320,
    },
    {
      'id': 'english',
      'name': 'English',
      'flag': '🇺🇸',
      'themeColor': Color(0xFF10B981),
      'level': 'Advanced',
      'progress': 85,
      'xp': 2850,
    },
    {
      'id': 'spanish',
      'name': 'Spanish',
      'flag': '🇪🇸',
      'themeColor': Color(0xFF8B5CF6),
      'level': 'Not started',
      'progress': 0,
      'xp': 0,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final activeLangs = _allLanguages
        .where((l) => (l['progress'] as int) > 0)
        .toList();
    final exploreLangs = _allLanguages
        .where((l) => (l['progress'] as int) == 0)
        .toList();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.all(isMobile ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            const Text(
              'Dashboard',
              style: TextStyle(
                color: AppColors.brand300,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 16),

            // Welcome Banner
            Container(
              padding: EdgeInsets.all(isMobile ? 16 : 32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.brand900.withValues(alpha: 0.7),
                    AppColors.brand700.withValues(alpha: 0.5),
                  ],
                ),
                borderRadius: BorderRadius.circular(isMobile ? 16 : 24),
                border: Border.all(
                  color: AppColors.brand500.withValues(alpha: 0.2),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Welcome, ${user?.name ?? 'Learner'}! 👋',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isMobile ? 22 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    state.streak.count > 0
                        ? 'You\'re doing great! You\'ve maintained a ${state.streak.count}-day streak. Keep up the momentum!'
                        : 'Start your learning journey today! Complete your first lesson to begin tracking progress.',
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: isMobile ? 13 : 15,
                    ),
                  ),
                  SizedBox(height: isMobile ? 14 : 20),
                  GlassButton(
                    onPressed: () => context.go('/languages'),
                    variant: GlassButtonVariant.primary,
                    isLarge: false,
                    fullWidth: isMobile,
                    icon: !isMobile
                        ? const Icon(
                            Icons.play_arrow_rounded,
                            color: Colors.white,
                          )
                        : null,
                    child: const Text('Start'),
                  ),
                ],
              ),
            ),
            SizedBox(height: isMobile ? 20 : 32),

            // Quick Stats Grid
            LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = isMobile ? 3 : 3;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: isMobile ? 8 : 16,
                    mainAxisSpacing: isMobile ? 8 : 16,
                    childAspectRatio: isMobile ? 0.82 : 2.6,
                  ),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    final stats = [
                      {
                        'label': 'Total XP',
                        'value': '${state.totalXp}',
                        'icon': Icons.workspace_premium_rounded,
                        'color': AppColors.brand300,
                        'bg': AppColors.brand500.withValues(alpha: 0.15),
                      },
                      {
                        'label': 'Weekly Streak',
                        'value': '${state.streak.count} Days',
                        'icon': Icons.local_fire_department_rounded,
                        'color': Colors.orange,
                        'bg': Colors.orange.withValues(alpha: 0.15),
                      },
                      {
                        'label': 'Completed',
                        'value': '28 Lessons',
                        'icon': Icons.track_changes_rounded,
                        'color': Colors.lightBlueAccent,
                        'bg': Colors.blue.withValues(alpha: 0.15),
                      },
                    ];
                    final stat = stats[index];
                    return _buildStatCard(
                      stat['label'] as String,
                      stat['value'] as String,
                      stat['icon'] as IconData,
                      stat['color'] as Color,
                      stat['bg'] as Color,
                      isMobile,
                    );
                  },
                );
              },
            ),
            SizedBox(height: isMobile ? 24 : 36),

            // Active Languages
            const Text(
              'My Languages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: isMobile ? 10 : 16),
            LayoutBuilder(
              builder: (context, constraints) {
                if (isMobile) {
                  return Column(
                    children: activeLangs.asMap().entries.map((entry) {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: entry.key == activeLangs.length - 1 ? 0 : 12,
                        ),
                        child: _buildLanguageCard(
                          context,
                          entry.value,
                          isMobile: true,
                          state: state,
                        ),
                      );
                    }).toList(),
                  );
                }

                final crossAxisCount = MediaQuery.sizeOf(context).width > 800
                    ? 2
                    : 1;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: 20,
                    childAspectRatio: MediaQuery.sizeOf(context).width > 800
                        ? 2.1
                        : 1.0,
                  ),
                  itemCount: activeLangs.length,
                  itemBuilder: (context, index) {
                    return _buildLanguageCard(
                      context,
                      activeLangs[index],
                      isMobile: false,
                      state: state,
                    );
                  },
                );
              },
            ),
            SizedBox(height: isMobile ? 24 : 36),

            // Explore More
            if (exploreLangs.isNotEmpty) ...[
              const Text(
                'Explore More',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: isMobile ? 10 : 16),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (isMobile) {
                    return Column(
                      children: exploreLangs.asMap().entries.map((entry) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: entry.key == exploreLangs.length - 1
                                ? 0
                                : 12,
                          ),
                          child: _buildLanguageCard(
                            context,
                            entry.value,
                            isMobile: true,
                            state: state,
                          ),
                        );
                      }).toList(),
                    );
                  }

                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 20,
                          mainAxisSpacing: 20,
                          childAspectRatio: 2.1,
                        ),
                    itemCount: exploreLangs.length,
                    itemBuilder: (context, index) {
                      return _buildLanguageCard(
                        context,
                        exploreLangs[index],
                        isMobile: false,
                        state: state,
                      );
                    },
                  );
                },
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageCard(
    BuildContext context,
    Map<String, dynamic> lang, {
    required bool isMobile,
    required AppState state,
  }) {
    final int liveXp = state.getLanguageXpFor(lang['id'] as String);
    return InkWell(
      onTap: () => context.go('/language/${lang['id']}'),
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        padding: EdgeInsets.fromLTRB(
          isMobile ? 16 : 16,
          isMobile ? 14 : 24,
          isMobile ? 16 : 24,
          isMobile ? 12 : 24,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(
                      lang['flag'] as String,
                      style: TextStyle(fontSize: isMobile ? 36 : 32),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lang['name'] as String,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isMobile ? 18 : 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          lang['level'] as String,
                          style: TextStyle(
                            color: AppColors.brand300,
                            fontSize: isMobile ? 13 : 12,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text(
                      'Total XP',
                      style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    Text(
                      '$liveXp',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: isMobile ? 16 : 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            SizedBox(height: isMobile ? 10 : 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Course Progress',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 13),
                ),
                Text(
                  '${lang['progress']}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: (lang['progress'] as int) / 100.0,
                minHeight: 8,
                backgroundColor: Colors.white10,
                color: lang['themeColor'] as Color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color bg,
    bool isMobile,
  ) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 10 : 16),
      child: isMobile
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 30,
                  height: 30,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(9),
                  ),
                  child: Icon(icon, color: color, size: 16),
                ),
                const SizedBox(height: 6),
                Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 10,
                  ),
                ),
              ],
            )
          : Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: color, size: 21),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        label,
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 13,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
