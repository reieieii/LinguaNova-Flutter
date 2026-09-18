import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguageStudyPage extends StatelessWidget {
  const LanguageStudyPage({
    super.key,
    required this.languageId,
  });

  final String languageId;

  // Lesson number (1-based) → minimum language level required to unlock.
  static const Map<int, int> _lessonRequiredLevel = {
    1: 1, // always open
    2: 2,
    3: 3,
    4: 4,
    5: 5,
  };

  @override
  Widget build(BuildContext context) {
    final langKey = languageId.toLowerCase();
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 600;
    final isJapanese = langKey == 'japanese';

    // Language-specific level from AppState
    final state = context.watch<AppState>();
    final langLevel = state.getLanguageLevel(langKey);

    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Breadcrumb
            Row(
              children: [
                InkWell(
                  onTap: () => context.go('/language/$langKey'),
                  child: Text(
                    '${langKey.substring(0, 1).toUpperCase()}${langKey.substring(1)} Hub',
                    style: const TextStyle(
                        color: AppColors.textMuted, fontSize: 14),
                  ),
                ),
                const Text(' / ',
                    style: TextStyle(color: AppColors.textMuted)),
                const Text(
                  'Study Curriculum',
                  style: TextStyle(
                    color: AppColors.brand300,
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            Text(
              'Study Curriculum & Roadmap',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 24 : 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Complete lessons step-by-step to build your vocabulary, grammar, and fluency.',
              style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: isMobile ? 14 : 16),
            ),
            const SizedBox(height: 16),

            // Level progress indicator
            _buildLevelBadge(langKey, langLevel, isMobile),
            const SizedBox(height: 24),

            // ── Japanese-only: Kana Chart Cards ──────────────────────────
            if (isJapanese) ...[
              _buildKanaChartSection(context, langKey, isMobile),
              const SizedBox(height: 32),
            ],

            // Unit 1
            _buildUnitSection(
              context,
              unitTitle: 'Unit 1: Fundamentals & Basic Greetings',
              lessons: [
                {
                  'id': 'lesson-1',
                  'lessonNum': 1,
                  'title': 'Lesson 1: Characters & Basic Sounds',
                  'desc': 'Introduction to Hiragana / Pinyin phonetics.',
                  'time': '15 mins',
                  'xp': 50,
                  'completed': true,
                },
                {
                  'id': 'lesson-2',
                  'lessonNum': 2,
                  'title': 'Lesson 2: Daily Greetings & Politeness',
                  'desc': 'Learn to say Hello, Thank you and Goodbye.',
                  'time': '20 mins',
                  'xp': 60,
                  'completed': false,
                },
                {
                  'id': 'lesson-3',
                  'lessonNum': 3,
                  'title': 'Lesson 3: Numbers 1-100 & Counting',
                  'desc': 'Count items, currency and time expressions.',
                  'time': '25 mins',
                  'xp': 70,
                  'completed': false,
                },
              ],
              langKey: langKey,
              langLevel: langLevel,
              isMobile: isMobile,
            ),
            const SizedBox(height: 32),

            // Unit 2
            _buildUnitSection(
              context,
              unitTitle: 'Unit 2: Essential Grammar & Sentence Structures',
              lessons: [
                {
                  'id': 'lesson-4',
                  'lessonNum': 4,
                  'title': 'Lesson 4: Subject Particles & Pronouns',
                  'desc': 'Form simple sentences with I, You, He, She.',
                  'time': '20 mins',
                  'xp': 65,
                  'completed': false,
                },
                {
                  'id': 'lesson-5',
                  'lessonNum': 5,
                  'title': 'Lesson 5: Verbs & Present Tense',
                  'desc': 'Eat, Drink, Go, See in present tense.',
                  'time': '30 mins',
                  'xp': 80,
                  'completed': false,
                },
              ],
              langKey: langKey,
              langLevel: langLevel,
              isMobile: isMobile,
            ),
          ],
        ),
      ),
    );
  }

  // ── Level badge ────────────────────────────────────────────────────────────

  Widget _buildLevelBadge(String langKey, int langLevel, bool isMobile) {
    final langName =
        '${langKey.substring(0, 1).toUpperCase()}${langKey.substring(1)}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.brand500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: AppColors.brand500.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.military_tech_rounded,
              color: AppColors.brand300, size: 18),
          const SizedBox(width: 8),
          Text(
            '$langName Level $langLevel',
            style: TextStyle(
              color: AppColors.brand300,
              fontSize: isMobile ? 12 : 13,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '• Complete lessons to level up',
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: isMobile ? 11 : 12,
            ),
          ),
        ],
      ),
    );
  }

  // ── Unit section ───────────────────────────────────────────────────────────

  Widget _buildUnitSection(
    BuildContext context, {
    required String unitTitle,
    required List<Map<String, dynamic>> lessons,
    required String langKey,
    required int langLevel,
    required bool isMobile,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unitTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 18 : 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...lessons.map((lesson) {
          final int lessonNum = lesson['lessonNum'] as int;
          final int requiredLevel =
              _lessonRequiredLevel[lessonNum] ?? lessonNum;
          final bool isLocked = langLevel < requiredLevel;
          final bool isCompleted = lesson['completed'] as bool;

          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: _buildLessonCard(
              context,
              lesson: lesson,
              langKey: langKey,
              isLocked: isLocked,
              isCompleted: isCompleted,
              requiredLevel: requiredLevel,
              isMobile: isMobile,
            ),
          );
        }),
      ],
    );
  }

  // ── Lesson card ────────────────────────────────────────────────────────────

  Widget _buildLessonCard(
    BuildContext context, {
    required Map<String, dynamic> lesson,
    required String langKey,
    required bool isLocked,
    required bool isCompleted,
    required int requiredLevel,
    required bool isMobile,
  }) {
    final langName =
        '${langKey.substring(0, 1).toUpperCase()}${langKey.substring(1)}';

    return InkWell(
      onTap: () {
        if (isLocked) {
          _showLockedDialog(context, requiredLevel, langName);
          return;
        }
        context.go('/language/$langKey/study/${lesson['id']}');
      },
      borderRadius: BorderRadius.circular(16),
      child: Opacity(
        opacity: isLocked ? 0.55 : 1.0,
        child: GlassCard(
          padding: EdgeInsets.all(isMobile ? 16 : 20),
          borderColor: isLocked
              ? Colors.white.withValues(alpha: 0.06)
              : null, // default border
          child: Row(
            children: [
              // Left icon
              Container(
                width: isMobile ? 40 : 48,
                height: isMobile ? 40 : 48,
                decoration: BoxDecoration(
                  color: isLocked
                      ? Colors.white.withValues(alpha: 0.05)
                      : isCompleted
                          ? Colors.green.withValues(alpha: 0.15)
                          : AppColors.brand500.withValues(alpha: 0.15),
                  borderRadius:
                      BorderRadius.circular(isMobile ? 12 : 14),
                ),
                child: Icon(
                  isLocked
                      ? Icons.lock_rounded
                      : isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.menu_book_rounded,
                  color: isLocked
                      ? AppColors.textMuted
                      : isCompleted
                          ? Colors.greenAccent
                          : AppColors.brand300,
                  size: isMobile ? 20 : 24,
                ),
              ),
              const SizedBox(width: 16),

              // Title + description
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      lesson['title'] as String,
                      style: TextStyle(
                        color: isLocked
                            ? AppColors.textMuted
                            : Colors.white,
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isLocked
                          ? 'Requires $langName Level $requiredLevel to unlock'
                          : lesson['desc'] as String,
                      style: TextStyle(
                        color: isLocked
                            ? AppColors.textMuted.withValues(alpha: 0.7)
                            : AppColors.textMuted,
                        fontSize: isMobile ? 11 : 13,
                        fontStyle: isLocked
                            ? FontStyle.italic
                            : FontStyle.normal,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),

              // Time + XP / lock badge
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${lesson['time']}',
                    style: TextStyle(
                        color: AppColors.textMuted,
                        fontSize: isMobile ? 10 : 12),
                  ),
                  const SizedBox(height: 4),
                  if (isLocked)
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6 : 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.06),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                            color:
                                Colors.white.withValues(alpha: 0.12)),
                      ),
                      child: Text(
                        'Lv $requiredLevel',
                        style: TextStyle(
                          color: AppColors.textMuted,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 9 : 11,
                        ),
                      ),
                    )
                  else
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: isMobile ? 6 : 8, vertical: 2),
                      decoration: BoxDecoration(
                        color:
                            AppColors.brand500.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '+${lesson['xp']} XP',
                        style: TextStyle(
                          color: AppColors.brand300,
                          fontWeight: FontWeight.bold,
                          fontSize: isMobile ? 9 : 11,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Lock dialog ────────────────────────────────────────────────────────────

  void _showLockedDialog(
      BuildContext context, int requiredLevel, String langName) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.dark800,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: const Row(
          children: [
            Text('🔒', style: TextStyle(fontSize: 22)),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                'Lesson Locked',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
        content: Text(
          'This lesson requires $langName Level $requiredLevel.\n\n'
          'Complete quizzes and lessons to earn XP and level up your '
          '$langName skills.',
          style: const TextStyle(
              color: AppColors.textMuted, fontSize: 14, height: 1.55),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text(
              'Got it',
              style: TextStyle(
                  color: AppColors.brand300, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  // ── Kana Chart Section (Japanese only) ────────────────────────────────────

  Widget _buildKanaChartSection(
      BuildContext context, String langKey, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 4,
              height: 20,
              decoration: BoxDecoration(
                color: AppColors.brand300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Kana Reference Charts',
              style: TextStyle(
                color: Colors.white,
                fontSize: isMobile ? 18 : 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        const Padding(
          padding: EdgeInsets.only(left: 14),
          child: Text(
            'Browse the complete Gojūon character tables with Romaji readings and example vocabulary.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 13),
          ),
        ),
        const SizedBox(height: 16),
        isMobile
            ? Column(
                children: [
                  _buildKanaCard(
                    context,
                    langKey: langKey,
                    chartType: 'hiragana',
                    kanaLabel: 'ひらがな',
                    title: 'Hiragana Chart',
                    subtitle: 'Gojūon · 46 characters',
                    desc:
                        'Native Japanese words, particles, and grammar endings.',
                    accentColor: AppColors.brand300,
                    isMobile: true,
                  ),
                  const SizedBox(height: 12),
                  _buildKanaCard(
                    context,
                    langKey: langKey,
                    chartType: 'katakana',
                    kanaLabel: 'カタカナ',
                    title: 'Katakana Chart',
                    subtitle: 'Gojūon · 46 characters',
                    desc: 'Loanwords, foreign names, and onomatopoeia.',
                    accentColor: const Color(0xFF60A5FA),
                    isMobile: true,
                  ),
                ],
              )
            : Row(
                children: [
                  Expanded(
                    child: _buildKanaCard(
                      context,
                      langKey: langKey,
                      chartType: 'hiragana',
                      kanaLabel: 'ひらがな',
                      title: 'Hiragana Chart',
                      subtitle: 'Gojūon · 46 characters',
                      desc:
                          'Native Japanese words, particles, and grammar endings.',
                      accentColor: AppColors.brand300,
                      isMobile: false,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _buildKanaCard(
                      context,
                      langKey: langKey,
                      chartType: 'katakana',
                      kanaLabel: 'カタカナ',
                      title: 'Katakana Chart',
                      subtitle: 'Gojūon · 46 characters',
                      desc: 'Loanwords, foreign names, and onomatopoeia.',
                      accentColor: const Color(0xFF60A5FA),
                      isMobile: false,
                    ),
                  ),
                ],
              ),
      ],
    );
  }

  Widget _buildKanaCard(
    BuildContext context, {
    required String langKey,
    required String chartType,
    required String kanaLabel,
    required String title,
    required String subtitle,
    required String desc,
    required Color accentColor,
    required bool isMobile,
  }) {
    return InkWell(
      onTap: () =>
          context.go('/language/$langKey/study/$chartType-chart'),
      borderRadius: BorderRadius.circular(16),
      child: GlassCard(
        padding: const EdgeInsets.all(20),
        borderRadius: 16,
        borderColor: accentColor.withValues(alpha: 0.3),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: accentColor.withValues(alpha: 0.35)),
                  ),
                  child: Center(
                    child: Text(
                      kanaLabel.substring(0, 1),
                      style: TextStyle(
                        color: accentColor,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Spacer(),
                Icon(Icons.arrow_forward_ios_rounded,
                    color: accentColor, size: 16),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 2),
            Text(
              '$kanaLabel · $subtitle',
              style: TextStyle(
                  color: accentColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(desc,
                style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 12,
                    height: 1.5)),
            const SizedBox(height: 14),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: [
                _kanaChip(
                    Icons.grid_on_rounded, '46 chars', accentColor),
                _kanaChip(
                    Icons.translate_rounded, 'Romaji', accentColor),
                _kanaChip(Icons.auto_stories_rounded, 'Vocabulary',
                    accentColor),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _kanaChip(IconData icon, String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: color),
          const SizedBox(width: 4),
          Text(label,
              style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
