import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguageLessonPage extends StatefulWidget {
  const LanguageLessonPage({
    super.key,
    required this.languageId,
    required this.lessonId,
  });

  final String languageId;
  final String lessonId;

  @override
  State<LanguageLessonPage> createState() => _LanguageLessonPageState();
}

class _LanguageLessonPageState extends State<LanguageLessonPage> {
  final SpeechService _speechService = SpeechService();
  bool _isCompleted = false;

  static const List<Map<String, String>> _sampleVocab = [
    {
      'word': 'こんにちは',
      'reading': 'Konnichiwa',
      'meaning': 'Hello / Good Afternoon',
    },
    {
      'word': 'ありがとう',
      'reading': 'Arigatou',
      'meaning': 'Thank you',
    },
    {
      'word': 'さようなら',
      'reading': 'Sayounara',
      'meaning': 'Goodbye',
    },
    {
      'word': 'すみません',
      'reading': 'Sumimasen',
      'meaning': 'Excuse me / Sorry',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final langKey = widget.languageId.toLowerCase();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Breadcrumb
          Row(
            children: [
              InkWell(
                onTap: () => context.go('/language/$langKey/study'),
                child: const Text(
                  'Study Roadmap',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                ),
              ),
              const Text(' / ', style: TextStyle(color: AppColors.textMuted)),
              Text(
                'Lesson: ${widget.lessonId}',
                style: const TextStyle(
                  color: AppColors.brand300,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Lesson Title Card
          GlassCard(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.brand500.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Unit 1 · Basic Greetings',
                        style: TextStyle(
                          color: AppColors.brand300,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Row(
                      children: const [
                        Icon(Icons.schedule_rounded, size: 16, color: AppColors.textMuted),
                        SizedBox(width: 4),
                        Text('15 mins', style: TextStyle(color: AppColors.textMuted, fontSize: 13)),
                        SizedBox(width: 12),
                        Icon(Icons.bolt_rounded, size: 16, color: Colors.amber),
                        SizedBox(width: 4),
                        Text('+50 XP', style: TextStyle(color: Colors.amber, fontWeight: FontWeight.bold, fontSize: 13)),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  'Lesson 1: Essential Daily Greetings & Politeness',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Learn how to greet native speakers in various formal and informal everyday scenarios.',
                  style: TextStyle(color: AppColors.textMuted, fontSize: 15),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // Vocabulary Cards with Audio Playback
          const Text(
            'Lesson Vocabulary & Pronunciation',
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
            children: _sampleVocab.map((v) {
              final cardWidth = MediaQuery.sizeOf(context).width > 800
                  ? (MediaQuery.sizeOf(context).width - 320) / 2
                  : double.infinity;

              return SizedBox(
                width: cardWidth,
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            v['word']!,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            v['reading']!,
                            style: const TextStyle(
                              color: AppColors.brand300,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            v['meaning']!,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                      // Audio Speaker Button
                      IconButton(
                        icon: const Icon(Icons.volume_up_rounded, color: AppColors.brand300, size: 28),
                        onPressed: () {
                          _speechService.speak(v['word']!, languageId: langKey);
                        },
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 32),

          // Grammar Explanation Note
          GlassCard(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  '💡 Grammar Note: Cultural Nuances',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'In Japanese culture, polite greetings like "Konnichiwa" are used between midday and evening. Bowing slightly while speaking demonstrates extra respect!',
                  style: TextStyle(
                    color: AppColors.textMain,
                    fontSize: 14,
                    height: 1.6,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),

          // Bottom Navigation & Completion Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GlassButton(
                onPressed: () => context.go('/language/$langKey/study'),
                variant: GlassButtonVariant.glass,
                child: const Text('Back to Study'),
              ),
              GlassButton(
                onPressed: () {
                  setState(() => _isCompleted = true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('🎉 Lesson Completed! +50 XP Earned!'),
                    ),
                  );
                },
                variant: _isCompleted ? GlassButtonVariant.glass : GlassButtonVariant.primary,
                icon: Icon(
                  _isCompleted ? Icons.check_circle_rounded : Icons.star_rounded,
                  color: Colors.white,
                ),
                child: Text(_isCompleted ? 'Completed' : 'Mark as Complete'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
