import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguageStudyPage extends StatelessWidget {
  const LanguageStudyPage({
    super.key,
    required this.languageId,
  });

  final String languageId;

  @override
  Widget build(BuildContext context) {
    final langKey = languageId.toLowerCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              InkWell(
                onTap: () => context.go('/language/$langKey'),
                child: Text(
                  '${langKey.substring(0, 1).toUpperCase()}${langKey.substring(1)} Hub',
                  style: const TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ),
              const Text(' / ', style: TextStyle(color: AppColors.textMuted)),
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

          const Text(
            'Study Curriculum & Roadmap',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Complete lessons step-by-step to build your vocabulary, grammar, and fluency.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Unit 1
          _buildUnitSection(
            context,
            unitTitle: 'Unit 1: Fundamentals & Basic Greetings',
            lessons: [
              {
                'id': 'lesson-1',
                'title': 'Lesson 1: Characters & Basic Sounds',
                'desc': 'Introduction to Hiragana / Pinyin phonetics.',
                'time': '15 mins',
                'xp': 50,
                'completed': true,
              },
              {
                'id': 'lesson-2',
                'title': 'Lesson 2: Daily Greetings & Politeness',
                'desc': 'Learn to say Hello, Thank you and Goodbye.',
                'time': '20 mins',
                'xp': 60,
                'completed': false,
              },
              {
                'id': 'lesson-3',
                'title': 'Lesson 3: Numbers 1-100 & Counting',
                'desc': 'Count items, currency and time expressions.',
                'time': '25 mins',
                'xp': 70,
                'completed': false,
              },
            ],
            langKey: langKey,
          ),
          const SizedBox(height: 32),

          // Unit 2
          _buildUnitSection(
            context,
            unitTitle: 'Unit 2: Essential Grammar & Sentence Structures',
            lessons: [
              {
                'id': 'lesson-4',
                'title': 'Lesson 4: Subject Particles & Pronouns',
                'desc': 'Form simple sentences with I, You, He, She.',
                'time': '20 mins',
                'xp': 65,
                'completed': false,
              },
              {
                'id': 'lesson-5',
                'title': 'Lesson 5: Verbs & Present Tense',
                'desc': 'Eat, Drink, Go, See in present tense.',
                'time': '30 mins',
                'xp': 80,
                'completed': false,
              },
            ],
            langKey: langKey,
          ),
        ],
      ),
    );
  }

  Widget _buildUnitSection(
    BuildContext context, {
    required String unitTitle,
    required List<Map<String, dynamic>> lessons,
    required String langKey,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          unitTitle,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        ...lessons.map((lesson) {
          final isCompleted = lesson['completed'] as bool;
          return Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: InkWell(
              onTap: () => context.go('/language/$langKey/study/${lesson['id']}'),
              borderRadius: BorderRadius.circular(16),
              child: GlassCard(
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isCompleted
                            ? Colors.green.withValues(alpha: 0.15)
                            : AppColors.brand500.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(
                        isCompleted ? Icons.check_circle_rounded : Icons.menu_book_rounded,
                        color: isCompleted ? Colors.greenAccent : AppColors.brand300,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            lesson['title'] as String,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            lesson['desc'] as String,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${lesson['time']}',
                          style: const TextStyle(color: AppColors.textMuted, fontSize: 12),
                        ),
                        const SizedBox(height: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.brand500.withValues(alpha: 0.15),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '+${lesson['xp']} XP',
                            style: const TextStyle(
                              color: AppColors.brand300,
                              fontWeight: FontWeight.bold,
                              fontSize: 11,
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
        }),
      ],
    );
  }
}
