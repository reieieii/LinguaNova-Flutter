import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguagePracticePage extends StatelessWidget {
  const LanguagePracticePage({super.key, required this.languageId});

  final String languageId;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 768 ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Interactive Practice Hub',
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
          const SizedBox(height: 28),

          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              final languages = [
                (
                  'english',
                  '🇬🇧 English',
                  'Vocabulary and letter recognition drills.',
                ),
                (
                  'japanese',
                  '🇯🇵 Japanese',
                  'Hiragana and Katakana character matching.',
                ),
                (
                  'chinese',
                  '🇨🇳 Chinese',
                  'Pinyin and character identification drills.',
                ),
                (
                  'spanish',
                  '🇪🇸 Spanish',
                  'Alphabet, accents, and vocabulary practice.',
                ),
                (
                  'korean',
                  '🇰🇷 Korean',
                  'Hangul vowel and consonant formation.',
                ),
              ];
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: languages.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isMobile ? 1 : 3,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isMobile ? 2.0 : 1.25,
                ),
                itemBuilder: (context, index) {
                  final language = languages[index];
                  return _practiceModeCard(
                    context,
                    title: language.$2,
                    desc: language.$3,
                    onTap: () =>
                        context.go('/language/${language.$1}/practice/quiz'),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _practiceModeCard(
    BuildContext context, {
    required String title,
    required String desc,
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
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                desc,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 14,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              GlassButton(
                onPressed: onTap,
                variant: GlassButtonVariant.primary,
                fullWidth: true,
                icon: const Icon(
                  Icons.play_arrow_rounded,
                  color: Colors.white,
                  size: 18,
                ),
                child: const Text('Start Quiz'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
