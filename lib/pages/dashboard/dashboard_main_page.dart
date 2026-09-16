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
      'xp': 1420
    },
    {
      'id': 'chinese',
      'name': 'Chinese',
      'flag': '🇨🇳',
      'themeColor': Color(0xFFF59E0B),
      'level': 'Beginner',
      'progress': 30,
      'xp': 640
    },
    {
      'id': 'korean',
      'name': 'Korean',
      'flag': '🇰🇷',
      'themeColor': Color(0xFF3B82F6),
      'level': 'Beginner',
      'progress': 15,
      'xp': 320
    },
    {
      'id': 'english',
      'name': 'English',
      'flag': '🇺🇸',
      'themeColor': Color(0xFF10B981),
      'level': 'Advanced',
      'progress': 85,
      'xp': 2850
    },
    {
      'id': 'spanish',
      'name': 'Spanish',
      'flag': '🇪🇸',
      'themeColor': Color(0xFF8B5CF6),
      'level': 'Not started',
      'progress': 0,
      'xp': 0
    },
  ];

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final user = state.currentUser;
    final activeLangs = _allLanguages.where((l) => (l['progress'] as int) > 0).toList();
    final exploreLangs = _allLanguages.where((l) => (l['progress'] as int) == 0).toList();
    final primaryLang = activeLangs.isNotEmpty ? activeLangs.first : _allLanguages.first;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
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
          const SizedBox(height: 16),

          // Welcome Banner
          Container(
            padding: const EdgeInsets.all(32),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.brand900.withValues(alpha: 0.7),
                  AppColors.brand700.withValues(alpha: 0.5),
                ],
              ),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: AppColors.brand500.withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome back, ${user?.name ?? 'Learner'}! 👋',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        state.streak.count > 0
                            ? 'You\'re doing great! You\'ve maintained a ${state.streak.count}-day streak. Keep up the momentum!'
                            : 'Start your learning journey today! Complete your first lesson to begin tracking progress.',
                        style: const TextStyle(
                          color: AppColors.textMain,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 20),
                      GlassButton(
                        onPressed: () => context.go('/language/${primaryLang['id']}'),
                        variant: GlassButtonVariant.primary,
                        icon: const Icon(Icons.play_arrow_rounded, color: Colors.white),
                        child: Text('Continue ${primaryLang['name']}'),
                      ),
                    ],
                  ),
                ),
                if (MediaQuery.sizeOf(context).width > 700)
                  Text(
                    primaryLang['flag'] as String,
                    style: const TextStyle(fontSize: 84),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 32),

          // Quick Stats Grid
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  'Total XP',
                  '2,450',
                  Icons.workspace_premium_rounded,
                  AppColors.brand300,
                  AppColors.brand500.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Weekly Streak',
                  '${state.streak.count} Days',
                  Icons.local_fire_department_rounded,
                  Colors.orange,
                  Colors.orange.withValues(alpha: 0.15),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildStatCard(
                  'Completed',
                  '28 Lessons',
                  Icons.track_changes_rounded,
                  Colors.lightBlueAccent,
                  Colors.blue.withValues(alpha: 0.15),
                ),
              ),
            ],
          ),
          const SizedBox(height: 36),

          // Active Languages
          const Text(
            'My Languages',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: activeLangs.map((lang) {
              final cardWidth = MediaQuery.sizeOf(context).width > 800
                  ? (MediaQuery.sizeOf(context).width - 320) / 2
                  : double.infinity;
              return SizedBox(
                width: cardWidth,
                child: InkWell(
                  onTap: () => context.go('/language/${lang['id']}'),
                  borderRadius: BorderRadius.circular(16),
                  child: GlassCard(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Text(
                                  lang['flag'] as String,
                                  style: const TextStyle(fontSize: 36),
                                ),
                                const SizedBox(width: 12),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      lang['name'] as String,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      lang['level'] as String,
                                      style: const TextStyle(
                                        color: AppColors.brand300,
                                        fontSize: 13,
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
                                  '${lang['xp']}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Course Progress',
                              style: TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 13,
                              ),
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
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 36),

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
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              children: exploreLangs.map((lang) {
                return InkWell(
                  onTap: () => context.go('/language/${lang['id']}'),
                  borderRadius: BorderRadius.circular(16),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    backgroundColor: Colors.white.withValues(alpha: 0.03),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(lang['flag'] as String, style: const TextStyle(fontSize: 28)),
                        const SizedBox(width: 12),
                        Text(
                          lang['name'] as String,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color,
    Color bg,
  ) {
    return GlassCard(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: bg,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
