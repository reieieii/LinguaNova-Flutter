import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguagePracticePage extends StatelessWidget {
  const LanguagePracticePage({
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
                'Practice Hub',
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
            'Interactive Practice Arena',
            style: TextStyle(
              color: Colors.white,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Reinforce your knowledge through quick quizzes, character drills, and listening practice.',
            style: TextStyle(color: AppColors.textMuted, fontSize: 16),
          ),
          const SizedBox(height: 32),

          // Practice Modes Grid
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: [
              _practiceModeCard(
                context,
                title: 'Basic Hiragana & Kana Quiz',
                desc: '10 random questions covering basic Japanese Kana characters.',
                icon: 'あ',
                color: AppColors.brand300,
                onTap: () => context.go('/language/$langKey/practice/hiragana'),
              ),
              _practiceModeCard(
                context,
                title: 'Vocabulary Speed Match',
                desc: 'Match words with their correct meaning against the timer.',
                icon: '⚡',
                color: Colors.amberAccent,
                onTap: () => context.go('/vocabulary'),
              ),
              _practiceModeCard(
                context,
                title: 'Listening & Pronunciation',
                desc: 'Listen to native audio clips and pick the correct sentence.',
                icon: '🎧',
                color: Colors.lightBlueAccent,
                onTap: () => context.go('/vocabulary'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _practiceModeCard(
    BuildContext context, {
    required String title,
    required String desc,
    required String icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final width = MediaQuery.sizeOf(context).width > 800
        ? (MediaQuery.sizeOf(context).width - 320) / 3
        : double.infinity;

    return SizedBox(
      width: width,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: GlassCard(
          padding: const EdgeInsets.all(28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(icon, style: const TextStyle(fontSize: 44)),
              const SizedBox(height: 16),
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Text(
                    'Start Game',
                    style: TextStyle(
                      color: color,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Icon(Icons.arrow_forward_rounded, color: color, size: 16),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
