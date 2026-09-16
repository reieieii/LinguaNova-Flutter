import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_card.dart';
import '../../presentation/widgets/glass_button.dart';

class LanguageHubPage extends StatefulWidget {
  const LanguageHubPage({super.key, required this.languageId});
  final String languageId;

  @override
  State<LanguageHubPage> createState() => _LanguageHubPageState();
}

class _LanguageHubPageState extends State<LanguageHubPage> {
  int _selectedTab = 0;

  static const List<String> _tabs = ['Hub', 'Study', 'Practice', 'Progress', 'Achievements'];

  static const Map<String, Map<String, dynamic>> _langConfigs = {
    'japanese': {
      'name': 'Japanese',
      'code': 'JP',
      'nativeName': '日本語',
      'flag': '🇯🇵',
      'themeColor': Color(0xFFEF4444),
      'certification': 'JLPT N5',
      'level': 'Beginner',
      'xp': 0,
      'progress': 45,
      'lessonsCompleted': 0,
      'totalLessons': 22,
      'streak': 5,
    },
    'chinese': {
      'name': 'Chinese',
      'code': 'ZH',
      'nativeName': '中文',
      'flag': '🇨🇳',
      'themeColor': Color(0xFFF59E0B),
      'certification': 'HSK 1',
      'level': 'Beginner',
      'xp': 640,
      'progress': 30,
      'lessonsCompleted': 6,
      'totalLessons': 20,
      'streak': 3,
    },
    'korean': {
      'name': 'Korean',
      'code': 'KR',
      'nativeName': '한국어',
      'flag': '🇰🇷',
      'themeColor': Color(0xFF3B82F6),
      'certification': 'TOPIK I',
      'level': 'Beginner',
      'xp': 320,
      'progress': 15,
      'lessonsCompleted': 3,
      'totalLessons': 20,
      'streak': 2,
    },
    'english': {
      'name': 'English',
      'code': 'EN',
      'nativeName': 'English',
      'flag': '🇺🇸',
      'themeColor': Color(0xFF10B981),
      'certification': 'CEFR C1',
      'level': 'Advanced',
      'xp': 2850,
      'progress': 85,
      'lessonsCompleted': 17,
      'totalLessons': 20,
      'streak': 12,
    },
    'spanish': {
      'name': 'Spanish',
      'code': 'ES',
      'nativeName': 'Español',
      'flag': '🇪🇸',
      'themeColor': Color(0xFF8B5CF6),
      'certification': 'DELE A1',
      'level': 'Not started',
      'xp': 0,
      'progress': 0,
      'lessonsCompleted': 0,
      'totalLessons': 20,
      'streak': 0,
    },
  };

  @override
  Widget build(BuildContext context) {
    final langKey = widget.languageId.toLowerCase();
    final config = _langConfigs[langKey] ?? _langConfigs['japanese']!;
    final Color themeColor = config['themeColor'] as Color;
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          _buildBreadcrumb(context, config),
          const SizedBox(height: 20),

          // Sub-Tabs Filter Bar
          _buildSubTabs(),
          const SizedBox(height: 24),

          // Hero Banner
          _buildHeroBanner(context, langKey, config, themeColor),
          const SizedBox(height: 28),

          // Quick Action Cards (4 cards)
          _buildQuickActionCards(context, langKey),
          const SizedBox(height: 20),

          // Stats Row (4 stats boxes)
          _buildStatsRow(config, state),
          const SizedBox(height: 32),

          // Study Modules Section
          _buildStudyModulesSection(context, langKey, themeColor),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context, Map<String, dynamic> config) {
    return Row(
      children: [
        InkWell(
          onTap: () => context.go('/dashboard'),
          child: const Text(
            'Dashboard',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        const Text(' / ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        InkWell(
          onTap: () => context.go('/languages'),
          child: const Text(
            'Languages',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        const Text(' / ', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
        Text(
          config['name'] as String,
          style: const TextStyle(
            color: AppColors.brand300,
            fontWeight: FontWeight.bold,
            fontSize: 13,
          ),
        ),
      ],
    );
  }

  Widget _buildSubTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(_tabs.length, (i) {
          final isActive = _selectedTab == i;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: GestureDetector(
              onTap: () => setState(() => _selectedTab = i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 9),
                decoration: BoxDecoration(
                  color: isActive
                      ? AppColors.brand500.withValues(alpha: 0.2)
                      : Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: isActive
                        ? AppColors.brand500.withValues(alpha: 0.6)
                        : Colors.white.withValues(alpha: 0.1),
                  ),
                ),
                child: Text(
                  _tabs[i],
                  style: TextStyle(
                    color: isActive ? Colors.white : AppColors.textMuted,
                    fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildHeroBanner(
    BuildContext context,
    String langKey,
    Map<String, dynamic> config,
    Color themeColor,
  ) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            themeColor.withValues(alpha: 0.18),
            AppColors.brand900.withValues(alpha: 0.6),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: themeColor.withValues(alpha: 0.3)),
        boxShadow: [
          BoxShadow(
            color: themeColor.withValues(alpha: 0.12),
            blurRadius: 30,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Language code + flag
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${config['code']} ${config['name']} ${config['nativeName']}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    config['flag'] as String,
                    style: const TextStyle(fontSize: 36),
                  ),
                ],
              ),
              const Spacer(),
              // Start button
              GlassButton(
                onPressed: () => context.go('/language/$langKey/study'),
                variant: GlassButtonVariant.primary,
                icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                child: const Text('Continue Learning'),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Badges row
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _heroBadge(Icons.track_changes_rounded, 'Level: ${config['level']}', AppColors.brand300),
              _heroBadge(Icons.workspace_premium_rounded, '${config['certification']}', Colors.amber),
              _heroBadge(Icons.bolt_rounded, 'XP: ${config['xp']}', Colors.lightGreenAccent),
              _heroBadge(Icons.local_fire_department_rounded, 'Streak: ${config['streak']} days', Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _heroBadge(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActionCards(BuildContext context, String langKey) {
    final cards = [
      {
        'title': 'Study',
        'subtitle': 'Continue lessons',
        'icon': Icons.auto_stories_rounded,
        'color': AppColors.brand300,
        'route': '/language/$langKey/study',
      },
      {
        'title': 'Practice',
        'subtitle': 'Test your skills',
        'icon': Icons.sports_esports_rounded,
        'color': const Color(0xFF4ADE80), // green
        'route': '/language/$langKey/practice',
      },
      {
        'title': 'Progress',
        'subtitle': 'Track your journey',
        'icon': Icons.insights_rounded,
        'color': const Color(0xFF60A5FA), // blue
        'route': '/progress',
      },
      {
        'title': 'Achievements',
        'subtitle': 'Earned badges & rewards',
        'icon': Icons.workspace_premium_rounded,
        'color': const Color(0xFFFBBF24), // amber
        'route': '/achievements',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return Row(
            children: cards.map((card) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    right: card != cards.last ? 12 : 0,
                  ),
                  child: _quickActionCard(context, card),
                ),
              );
            }).toList(),
          );
        }
        return Column(
          children: cards.map((card) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: _quickActionCard(context, card),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _quickActionCard(BuildContext context, Map<String, dynamic> card) {
    final Color color = card['color'] as Color;
    return InkWell(
      onTap: () => context.go(card['route'] as String),
      borderRadius: BorderRadius.circular(14),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        borderRadius: 14,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(card['icon'] as IconData, color: color, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    card['title'] as String,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    card['subtitle'] as String,
                    style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios_rounded, color: color, size: 14),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsRow(Map<String, dynamic> config, AppState state) {
    final int progress = config['progress'] as int;
    final int lessonsCompleted = config['lessonsCompleted'] as int;
    final int totalLessons = config['totalLessons'] as int;
    final int xp = config['xp'] as int;
    final int streak = config['streak'] as int;

    final stats = [
      {
        'label': 'Overall Progress',
        'value': '$progress%',
        'icon': Icons.donut_large_rounded,
        'color': AppColors.brand300,
        'sub': 'Course completion',
      },
      {
        'label': 'Lessons Completed',
        'value': '$lessonsCompleted/$totalLessons',
        'icon': Icons.check_circle_outline_rounded,
        'color': const Color(0xFF4ADE80),
        'sub': 'Lessons done',
      },
      {
        'label': 'Total XP',
        'value': '$xp XP',
        'icon': Icons.bolt_rounded,
        'color': const Color(0xFFFBBF24),
        'sub': 'Experience points',
      },
      {
        'label': 'Current Streak',
        'value': '$streak Days',
        'icon': Icons.local_fire_department_rounded,
        'color': Colors.orange,
        'sub': 'Consecutive days',
      },
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth > 600;
        if (isWide) {
          return Row(
            children: stats.map((s) {
              return Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: s != stats.last ? 12 : 0),
                  child: _statsBox(s),
                ),
              );
            }).toList(),
          );
        }
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: stats.map((s) {
            return SizedBox(
              width: (constraints.maxWidth - 12) / 2,
              child: _statsBox(s),
            );
          }).toList(),
        );
      },
    );
  }

  Widget _statsBox(Map<String, dynamic> stat) {
    final Color color = stat['color'] as Color;
    return GlassCard(
      padding: const EdgeInsets.all(16),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(stat['icon'] as IconData, color: color, size: 18),
              ),
              const Spacer(),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            stat['value'] as String,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            stat['label'] as String,
            style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildStudyModulesSection(BuildContext context, String langKey, Color themeColor) {
    final modules = [
      {
        'title': 'Basic Characters & Kana',
        'desc': 'Learn Hiragana, Katakana and basic strokes.',
        'progress': 0.90,
        'lessons': 5,
        'lessonId': 'lesson-1',
        'tag': 'Foundation',
        'tagColor': Colors.greenAccent,
      },
      {
        'title': 'Essential Greetings',
        'desc': 'Everyday greetings, polite phrases & introduction.',
        'progress': 0.65,
        'lessons': 4,
        'lessonId': 'lesson-2',
        'tag': 'Communication',
        'tagColor': AppColors.brand300,
      },
      {
        'title': 'Numbers & Counter Suffixes',
        'desc': 'Count items, people, hours & currency.',
        'progress': 0.40,
        'lessons': 4,
        'lessonId': 'lesson-3',
        'tag': 'Math',
        'tagColor': Colors.amberAccent,
      },
      {
        'title': 'Grammar Fundamentals',
        'desc': 'Particles, sentence patterns and basic verbs.',
        'progress': 0.20,
        'lessons': 5,
        'lessonId': 'lesson-4',
        'tag': 'Grammar',
        'tagColor': Colors.lightBlueAccent,
      },
      {
        'title': 'Daily Conversation',
        'desc': 'Common phrases for everyday situations.',
        'progress': 0.0,
        'lessons': 4,
        'lessonId': 'lesson-5',
        'tag': 'Speaking',
        'tagColor': Colors.pinkAccent,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Study Modules',
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            TextButton(
              onPressed: () => context.go('/language/$langKey/study'),
              child: const Text(
                'View All →',
                style: TextStyle(color: AppColors.brand300, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        LayoutBuilder(
          builder: (context, constraints) {
            final isWide = constraints.maxWidth > 700;
            if (isWide) {
              return Wrap(
                spacing: 16,
                runSpacing: 16,
                children: modules.map((m) {
                  return SizedBox(
                    width: (constraints.maxWidth - 16) / 2,
                    child: _moduleCard(context, langKey, m, themeColor),
                  );
                }).toList(),
              );
            }
            return Column(
              children: modules.map((m) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _moduleCard(context, langKey, m, themeColor),
                );
              }).toList(),
            );
          },
        ),
        const SizedBox(height: 28),

        // Hiragana Quiz CTA
        _buildHiraganaQuizCTA(context, langKey),
      ],
    );
  }

  Widget _moduleCard(
    BuildContext context,
    String langKey,
    Map<String, dynamic> m,
    Color themeColor,
  ) {
    final double progress = m['progress'] as double;
    final Color tagColor = m['tagColor'] as Color;
    final bool isCompleted = progress >= 1.0;

    return InkWell(
      onTap: () => context.go('/language/$langKey/study/${m['lessonId']}'),
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 16,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Tag badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                  decoration: BoxDecoration(
                    color: tagColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: tagColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    m['tag'] as String,
                    style: TextStyle(color: tagColor, fontSize: 10, fontWeight: FontWeight.bold),
                  ),
                ),
                if (isCompleted)
                  const Icon(Icons.check_circle_rounded, color: Colors.greenAccent, size: 18),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              m['title'] as String,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              m['desc'] as String,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Icon(Icons.menu_book_rounded, size: 13, color: AppColors.textMuted),
                const SizedBox(width: 4),
                Text(
                  '${m['lessons']} lessons',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 11),
                ),
                const Spacer(),
                Text(
                  '${(progress * 100).toInt()}%',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white.withValues(alpha: 0.08),
                color: isCompleted ? Colors.greenAccent : themeColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHiraganaQuizCTA(BuildContext context, String langKey) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Colors.amberAccent.withValues(alpha: 0.12),
            AppColors.brand700.withValues(alpha: 0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.amberAccent.withValues(alpha: 0.25)),
      ),
      child: Row(
        children: [
          const Text('🎮', style: TextStyle(fontSize: 36)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hiragana Quiz',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Practice Japanese character recognition with interactive flashcards!',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 12, height: 1.4),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          GlassButton(
            onPressed: () => context.go('/language/$langKey/practice/hiragana'),
            variant: GlassButtonVariant.primary,
            child: const Text('Play Now'),
          ),
        ],
      ),
    );
  }
}
