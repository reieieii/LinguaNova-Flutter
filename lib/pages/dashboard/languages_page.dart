import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class LanguagesPage extends StatelessWidget {
  const LanguagesPage({super.key});

  static const _languages = [
    {
      'id': 'japanese',
      'name': 'Japanese',
      'flag': '🇯🇵',
      'desc': 'Master Kanji, Hiragana, and Katakana.',
      'diff': 'Hard',
      'hours': '2,200h',
    },
    {
      'id': 'chinese',
      'name': 'Chinese',
      'flag': '🇨🇳',
      'desc': 'Learn Mandarin, Pinyin, and Hanzi.',
      'diff': 'Hard',
      'hours': '2,200h',
    },
    {
      'id': 'korean',
      'name': 'Korean',
      'flag': '🇰🇷',
      'desc': 'Read Hangul and learn grammar naturally.',
      'diff': 'Medium',
      'hours': '1,200h',
    },
    {
      'id': 'english',
      'name': 'English',
      'flag': '🇺🇸',
      'desc': 'Perfect your pronunciation and idioms.',
      'diff': 'Easy',
      'hours': '600h',
    },
    {
      'id': 'spanish',
      'name': 'Spanish',
      'flag': '🇪🇸',
      'desc': 'Converse fluently in real-life situations.',
      'diff': 'Easy',
      'hours': '600h',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'All Languages',
              style: TextStyle(
                color: Colors.white,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select a language module to start or continue your study journey.',
              style: TextStyle(color: AppColors.textMuted, fontSize: 16),
            ),
            const SizedBox(height: 32),
            LayoutBuilder(
              builder: (context, constraints) {
                final isWide = constraints.maxWidth > 800;
                final isMobile = constraints.maxWidth < 600;
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isWide ? 2 : 1,
                    crossAxisSpacing: 20,
                    mainAxisSpacing: isMobile ? 12 : 20,
                    childAspectRatio: isWide ? 1.65 : 1.45,
                  ),
                  itemCount: _languages.length,
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    return InkWell(
                      onTap: () => context.go('/language/${lang['id']}'),
                      borderRadius: BorderRadius.circular(16),
                      child: GlassCard(
                        padding: EdgeInsets.all(isMobile ? 18 : 22),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              lang['flag']!,
                              style: const TextStyle(fontSize: 56),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              lang['name']!,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              lang['desc']!,
                              style: const TextStyle(
                                color: AppColors.textMuted,
                                fontSize: 14,
                                height: 1.5,
                              ),
                            ),
                            const SizedBox(height: 14),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.brand500.withValues(
                                      alpha: 0.15,
                                    ),
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  child: Text(
                                    lang['diff']!,
                                    style: const TextStyle(
                                      color: AppColors.brand300,
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Text(
                                  '~${lang['hours']}',
                                  style: const TextStyle(
                                    color: AppColors.textMuted,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
