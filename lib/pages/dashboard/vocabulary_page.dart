import 'package:flutter/material.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/widgets/glass_card.dart';

class VocabularyPage extends StatefulWidget {
  const VocabularyPage({super.key});

  @override
  State<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends State<VocabularyPage> {
  final SpeechService _speechService = SpeechService();
  String _selectedLang = 'japanese';

  static const List<Map<String, String>> _vocabList = [
    {
      'word': 'こんにちは',
      'reading': 'Konnichiwa',
      'meaning': 'Hello / Good afternoon',
      'lang': 'japanese',
      'status': 'Mastered',
    },
    {
      'word': 'ありがとう',
      'reading': 'Arigatou',
      'meaning': 'Thank you',
      'lang': 'japanese',
      'status': 'Learning',
    },
    {
      'word': 'さようなら',
      'reading': 'Sayounara',
      'meaning': 'Goodbye',
      'lang': 'japanese',
      'status': 'Mastered',
    },
    {
      'word': '你好',
      'reading': 'Nǐ hǎo',
      'meaning': 'Hello',
      'lang': 'chinese',
      'status': 'Mastered',
    },
    {
      'word': '谢谢',
      'reading': 'Xièxie',
      'meaning': 'Thank you',
      'lang': 'chinese',
      'status': 'Learning',
    },
    {
      'word': '안녕하세요',
      'reading': 'Annyeonghaseyo',
      'meaning': 'Hello (polite)',
      'lang': 'korean',
      'status': 'Learning',
    },
    {
      'word': '감사합니다',
      'reading': 'Gamsahabnida',
      'meaning': 'Thank you (formal)',
      'lang': 'korean',
      'status': 'Mastered',
    },
    {
      'word': 'Hola',
      'reading': 'Oh-lah',
      'meaning': 'Hello',
      'lang': 'spanish',
      'status': 'Mastered',
    },
    {
      'word': 'Gracias',
      'reading': 'Grah-see-ahs',
      'meaning': 'Thank you',
      'lang': 'spanish',
      'status': 'Learning',
    },
    {
      'word': 'Hello',
      'reading': 'heh-LOH',
      'meaning': 'A greeting',
      'lang': 'english',
      'status': 'Mastered',
    },
    {
      'word': 'Thank you',
      'reading': 'thank yoo',
      'meaning': 'A polite expression of gratitude',
      'lang': 'english',
      'status': 'Learning',
    },
    {
      'word': 'Goodbye',
      'reading': 'good-BYE',
      'meaning': 'A parting phrase',
      'lang': 'english',
      'status': 'Mastered',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _vocabList
        .where((item) => item['lang'] == _selectedLang)
        .toList();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.all(MediaQuery.sizeOf(context).width < 768 ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              final heading = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Vocabulary Deck',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Listen, practice, and review your collected vocabulary.',
                    style: TextStyle(color: AppColors.textMuted, fontSize: 14),
                  ),
                ],
              );

              final selector = _buildLanguageSelector();
              return isMobile
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        heading,
                        const SizedBox(height: 16),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: selector,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [heading, selector],
                    );
            },
          ),
          SizedBox(height: MediaQuery.sizeOf(context).width < 768 ? 24 : 32),

          // Vocab Grid
          LayoutBuilder(
            builder: (context, constraints) {
              final isMobile = constraints.maxWidth < 768;
              final crossAxisCount = isMobile ? 1 : 3;
              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: isMobile ? 1.7 : 1.35,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final item = filtered[index];
                  final isMastered = item['status'] == 'Mastered';
                  return GlassCard(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: isMastered
                                    ? Colors.green.withValues(alpha: 0.15)
                                    : Colors.amber.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                item['status']!,
                                style: TextStyle(
                                  color: isMastered
                                      ? Colors.greenAccent
                                      : Colors.amberAccent,
                                  fontSize: 11,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            // TTS Audio Play Button
                            IconButton(
                              icon: const Icon(
                                Icons.volume_up_rounded,
                                color: AppColors.brand300,
                              ),
                              onPressed: () {
                                _speechService.speak(
                                  item['word']!,
                                  languageId: _selectedLang,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['word']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          item['reading']!,
                          style: const TextStyle(
                            color: AppColors.brand300,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['meaning']!,
                          style: const TextStyle(
                            color: AppColors.textMuted,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.brand500.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.brand500.withValues(alpha: 0.3)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedLang,
          dropdownColor: AppColors.dark800,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
          items: const [
            DropdownMenuItem(value: 'japanese', child: Text('🇯🇵 Japanese')),
            DropdownMenuItem(value: 'chinese', child: Text('🇨🇳 Chinese')),
            DropdownMenuItem(value: 'korean', child: Text('🇰🇷 Korean')),
            DropdownMenuItem(value: 'spanish', child: Text('🇪🇸 Spanish')),
            DropdownMenuItem(value: 'english', child: Text('🇺🇸 English')),
          ],
          onChanged: (val) {
            if (val != null) setState(() => _selectedLang = val);
          },
        ),
      ),
    );
  }
}
