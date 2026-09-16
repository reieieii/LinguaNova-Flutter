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
      'status': 'Mastered'
    },
    {
      'word': 'ありがとう',
      'reading': 'Arigatou',
      'meaning': 'Thank you',
      'lang': 'japanese',
      'status': 'Learning'
    },
    {
      'word': 'さようなら',
      'reading': 'Sayounara',
      'meaning': 'Goodbye',
      'lang': 'japanese',
      'status': 'Mastered'
    },
    {
      'word': '你好',
      'reading': 'Nǐ hǎo',
      'meaning': 'Hello',
      'lang': 'chinese',
      'status': 'Mastered'
    },
    {
      'word': '谢谢',
      'reading': 'Xièxie',
      'meaning': 'Thank you',
      'lang': 'chinese',
      'status': 'Learning'
    },
    {
      'word': '안녕하세요',
      'reading': 'Annyeonghaseyo',
      'meaning': 'Hello (polite)',
      'lang': 'korean',
      'status': 'Learning'
    },
    {
      'word': '감사합니다',
      'reading': 'Gamsahabnida',
      'meaning': 'Thank you (formal)',
      'lang': 'korean',
      'status': 'Mastered'
    },
    {
      'word': 'Hola',
      'reading': 'Oh-lah',
      'meaning': 'Hello',
      'lang': 'spanish',
      'status': 'Mastered'
    },
    {
      'word': 'Gracias',
      'reading': 'Grah-see-ahs',
      'meaning': 'Thank you',
      'lang': 'spanish',
      'status': 'Learning'
    },
  ];

  @override
  Widget build(BuildContext context) {
    final filtered = _vocabList.where((item) => item['lang'] == _selectedLang).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
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
              ),
              // Language Selector Dropdown
              Container(
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
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    items: const [
                      DropdownMenuItem(value: 'japanese', child: Text('🇯🇵 Japanese')),
                      DropdownMenuItem(value: 'chinese', child: Text('🇨🇳 Chinese')),
                      DropdownMenuItem(value: 'korean', child: Text('🇰🇷 Korean')),
                      DropdownMenuItem(value: 'spanish', child: Text('🇪🇸 Spanish')),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLang = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Vocab Grid
          Wrap(
            spacing: 20,
            runSpacing: 20,
            children: filtered.map((item) {
              final cardWidth = MediaQuery.sizeOf(context).width > 800
                  ? (MediaQuery.sizeOf(context).width - 320) / 3
                  : double.infinity;
              final isMastered = item['status'] == 'Mastered';

              return SizedBox(
                width: cardWidth,
                child: GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: isMastered
                                  ? Colors.green.withValues(alpha: 0.15)
                                  : Colors.amber.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              item['status']!,
                              style: TextStyle(
                                color: isMastered ? Colors.greenAccent : Colors.amberAccent,
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          // TTS Audio Play Button
                          IconButton(
                            icon: const Icon(Icons.volume_up_rounded, color: AppColors.brand300),
                            onPressed: () {
                              _speechService.speak(item['word']!, languageId: _selectedLang);
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
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
