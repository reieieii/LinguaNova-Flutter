import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  static const List<Map<String, dynamic>> _badges = [
    {
      'title': 'Streak Master',
      'desc': 'Maintain a 7-day study streak',
      'icon': '🔥',
      'unlocked': true,
      'progress': '7/7'
    },
    {
      'title': 'Kanji Scholar',
      'desc': 'Master 50 Kanji characters',
      'icon': '⛩️',
      'unlocked': true,
      'progress': '50/50'
    },
    {
      'title': 'Polyglot Explorer',
      'desc': 'Start learning 3 different languages',
      'icon': '🌍',
      'unlocked': true,
      'progress': '3/3'
    },
    {
      'title': 'Vocab Master',
      'desc': 'Collect 200 vocabulary words',
      'icon': '📚',
      'unlocked': false,
      'progress': '124/200'
    },
    {
      'title': 'Quiz Champion',
      'desc': 'Score 100% on 10 practice quizzes',
      'icon': '🏆',
      'unlocked': false,
      'progress': '6/10'
    },
    {
      'title': 'Night Owl',
      'desc': 'Complete lessons after 10 PM',
      'icon': '🦉',
      'unlocked': true,
      'progress': 'Unlocked'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Achievements & Badges',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Earn badges by reaching learning milestones and maintaining your habit.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 32),
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: _badges.map((b) {
              final cardWidth = MediaQuery.sizeOf(context).width > 800
                  ? (MediaQuery.sizeOf(context).width - 320) / 3
                  : double.infinity;
              final unlocked = b['unlocked'] as bool;

              return SizedBox(
                width: cardWidth,
                child: GlassCard(
                  padding: const EdgeInsets.all(24),
                  backgroundColor: unlocked
                      ? AppColors.glassCardBg
                      : Colors.white.withValues(alpha: 0.02),
                  borderColor: unlocked
                      ? AppColors.brand500.withValues(alpha: 0.4)
                      : Colors.white10,
                  child: Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: unlocked
                              ? AppColors.brand500.withValues(alpha: 0.15)
                              : Colors.white.withValues(alpha: 0.05),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            b['icon'] as String,
                            style: TextStyle(
                              fontSize: 32,
                              color: unlocked ? null : Colors.grey,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              b['title'] as String,
                              style: TextStyle(
                                color: unlocked ? Colors.white : AppColors.textMuted,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              b['desc'] as String,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                              decoration: BoxDecoration(
                                color: unlocked
                                    ? AppColors.brand500.withValues(alpha: 0.15)
                                    : Colors.white10,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                b['progress'] as String,
                                style: TextStyle(
                                  color: unlocked ? AppColors.brand300 : AppColors.textMuted,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
