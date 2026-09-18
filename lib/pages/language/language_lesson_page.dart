import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class LessonVocabulary {
  const LessonVocabulary(this.term, this.reading, this.meaning);
  final String term;
  final String reading;
  final String meaning;
}

class LessonExample {
  const LessonExample(this.text, this.reading, this.meaning);
  final String text;
  final String reading;
  final String meaning;
}

class LessonContent {
  const LessonContent({
    required this.languageCode,
    required this.languageName,
    required this.lessonTitle,
    required this.categoryTitle,
    required this.progress,
    required this.estimatedTime,
    required this.difficulty,
    required this.xpReward,
    required this.explanation,
    required this.vocabulary,
    required this.examples,
  });

  final String languageCode;
  final String languageName;
  final String lessonTitle;
  final String categoryTitle;
  final int progress;
  final String estimatedTime;
  final String difficulty;
  final int xpReward;
  final List<String> explanation;
  final List<LessonVocabulary> vocabulary;
  final List<LessonExample> examples;

  static LessonContent forLanguage(String languageCode) {
    switch (languageCode.toLowerCase()) {
      case 'chinese':
        return const LessonContent(
          languageCode: 'chinese',
          languageName: 'Chinese',
          lessonTitle: 'Pinyin Basics',
          categoryTitle: 'Beginner Chinese',
          progress: 20,
          estimatedTime: '40 min',
          difficulty: 'Beginner',
          xpReward: 50,
          explanation: [
            'Pinyin (拼音) is the official romanization system for Standard Chinese. It uses the Latin alphabet to represent the sounds of Mandarin Chinese.',
            'Pinyin consists of initial consonants, final vowels, and tones. Each Mandarin syllable combines these elements.',
            'The four main tones are first tone (high level), second tone (rising), third tone (falling-rising), and fourth tone (falling). There is also a neutral tone.',
          ],
          vocabulary: [
            LessonVocabulary('你好', 'nǐ hǎo', 'Hello'),
            LessonVocabulary('谢谢', 'xiè xie', 'Thank you'),
            LessonVocabulary('再见', 'zài jiàn', 'Goodbye'),
            LessonVocabulary('对不起', 'duì bù qǐ', 'Sorry'),
          ],
          examples: [
            LessonExample('你好', 'nǐ hǎo', 'Hello'),
            LessonExample(
              '我很好，谢谢。',
              'wǒ hěn hǎo, xiè xie.',
              'I am very well, thank you.',
            ),
          ],
        );
      case 'korean':
        return const LessonContent(
          languageCode: 'korean',
          languageName: 'Korean',
          lessonTitle: 'Hangul Basics',
          categoryTitle: 'Beginner Korean',
          progress: 15,
          estimatedTime: '35 min',
          difficulty: 'Beginner',
          xpReward: 50,
          explanation: [
            'Hangul (한글) is the Korean alphabet, created in the 15th century by King Sejong the Great. Its logical design makes it approachable for new learners.',
            'Hangul consists of 14 basic consonants and 10 basic vowels. These letters combine into syllable blocks.',
            'Basic consonants include ㄱ, ㄴ, ㄷ, ㄹ, ㅁ, ㅂ, ㅅ, ㅇ, ㅈ, ㅊ, ㅋ, ㅌ, ㅍ, ㅎ. Basic vowels include ㅏ, ㅑ, ㅓ, ㅕ, ㅗ, ㅛ, ㅜ, ㅠ, ㅡ, ㅣ.',
          ],
          vocabulary: [
            LessonVocabulary('안녕하세요', 'annyeonghaseyo', 'Hello'),
            LessonVocabulary('감사합니다', 'gamsahamnida', 'Thank you'),
            LessonVocabulary('안녕히 가세요', 'annyeonghi gaseyo', 'Goodbye'),
            LessonVocabulary('죄송합니다', 'joesonghamnida', 'Sorry'),
          ],
          examples: [
            LessonExample('안녕하세요', 'annyeonghaseyo', 'Hello'),
            LessonExample('감사합니다', 'gamsahamnida', 'Thank you'),
          ],
        );
      case 'english':
        return const LessonContent(
          languageCode: 'english',
          languageName: 'English',
          lessonTitle: 'Basic Greetings',
          categoryTitle: 'Beginner English',
          progress: 25,
          estimatedTime: '25 min',
          difficulty: 'Beginner',
          xpReward: 40,
          explanation: [
            'English greetings change with context, time of day, and formality. Hello and Hi are common in everyday conversations.',
            'Use polite phrases such as Thank you, Excuse me, and Sorry to show respect and keep conversations friendly.',
            'Listen for stress and intonation: a warm tone can make a simple greeting sound more natural.',
          ],
          vocabulary: [
            LessonVocabulary('Hello', 'heh-LOH', 'A greeting'),
            LessonVocabulary(
              'Thank you',
              'thank yoo',
              'A polite expression of gratitude',
            ),
            LessonVocabulary('Goodbye', 'good-BYE', 'A parting phrase'),
            LessonVocabulary(
              'Excuse me / Sorry',
              'ex-KYOOZ mee / SOR-ee',
              'Polite apology or request',
            ),
          ],
          examples: [
            LessonExample(
              'Hello! How are you?',
              'heh-LOH, how ar yoo?',
              'A friendly greeting',
            ),
            LessonExample(
              'Thank you very much.',
              'thank yoo veh-ree much',
              'A polite response',
            ),
          ],
        );
      case 'spanish':
        return const LessonContent(
          languageCode: 'spanish',
          languageName: 'Spanish',
          lessonTitle: 'Spanish Greetings',
          categoryTitle: 'Beginner Spanish',
          progress: 20,
          estimatedTime: '30 min',
          difficulty: 'Beginner',
          xpReward: 50,
          explanation: [
            'Spanish pronunciation is consistent: vowels generally keep one clear sound. Accent marks show which syllable receives stress.',
            'Spanish nouns have grammatical gender. Learn each noun with its article, such as el or la, from the beginning.',
            'Hola is an informal greeting. Use gracias, adiós, lo siento, and por favor to handle common polite situations.',
          ],
          vocabulary: [
            LessonVocabulary('Hola', '/ˈo.la/', 'Hello'),
            LessonVocabulary('Gracias', '/ˈɡɾa.sjas/', 'Thank you'),
            LessonVocabulary('Adiós', '/aˈðjos/', 'Goodbye'),
            LessonVocabulary(
              'Lo siento / Por favor',
              '/lo ˈsjen.to/ /poɾ faˈβoɾ/',
              'Sorry / Please',
            ),
          ],
          examples: [
            LessonExample(
              '¡Hola! ¿Cómo estás?',
              '/ˈo.la ˈko.mo esˈtas/',
              'Hello! How are you?',
            ),
            LessonExample(
              'Muchas gracias.',
              '/ˈmu.tʃas ˈɡɾa.sjas/',
              'Thank you very much.',
            ),
          ],
        );
      case 'japanese':
      default:
        return const LessonContent(
          languageCode: 'japanese',
          languageName: 'Japanese',
          lessonTitle: 'Essential Daily Greetings & Politeness',
          categoryTitle: 'Beginner Japanese',
          progress: 20,
          estimatedTime: '30 min',
          difficulty: 'Beginner',
          xpReward: 50,
          explanation: [
            'Japanese uses three writing systems: Hiragana for native words and grammar, Katakana for loanwords, and Kanji for meaning-bearing characters.',
            'Hiragana and Katakana each have 46 basic characters. Kanji adds meaning and is introduced gradually through common words.',
            'Polite greetings such as こんにちは and ありがとうございます are essential for everyday conversations and show respect.',
          ],
          vocabulary: [
            LessonVocabulary('こんにちは', 'Konnichiwa', 'Hello / Good afternoon'),
            LessonVocabulary('ありがとう', 'Arigatou', 'Thank you'),
            LessonVocabulary('さようなら', 'Sayounara', 'Goodbye'),
            LessonVocabulary('すみません', 'Sumimasen', 'Excuse me / Sorry'),
          ],
          examples: [
            LessonExample('こんにちは', 'Konnichiwa', 'Hello / Good afternoon'),
            LessonExample(
              'ありがとうございます',
              'Arigatou gozaimasu',
              'Thank you very much',
            ),
          ],
        );
    }
  }
}

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

  @override
  Widget build(BuildContext context) {
    final content = LessonContent.forLanguage(widget.languageId);
    final isMobile = MediaQuery.sizeOf(context).width < 600;
    return SingleChildScrollView(
      padding: EdgeInsets.all(isMobile ? 16 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBreadcrumb(context, content),
          SizedBox(height: isMobile ? 16 : 20),
          _buildLessonHeader(content, isMobile),
          SizedBox(height: isMobile ? 20 : 24),
          _buildExplanation(content, isMobile),
          SizedBox(height: isMobile ? 16 : 20),
          _buildVocabulary(content, isMobile),
          SizedBox(height: isMobile ? 16 : 20),
          _buildPronunciation(content, isMobile),
          SizedBox(height: isMobile ? 24 : 32),
          _buildLessonActions(context, content, isMobile),
        ],
      ),
    );
  }

  Widget _buildBreadcrumb(BuildContext context, LessonContent content) {
    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      children: [
        InkWell(
          onTap: () => context.go('/language/${content.languageCode}/study'),
          child: const Text(
            'Study Roadmap',
            style: TextStyle(color: AppColors.textMuted, fontSize: 14),
          ),
        ),
        const Text(' / ', style: TextStyle(color: AppColors.textMuted)),
        Text(
          content.lessonTitle,
          style: const TextStyle(
            color: AppColors.brand300,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildLessonHeader(LessonContent content, bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content.categoryTitle,
          style: const TextStyle(
            color: AppColors.brand300,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          content.lessonTitle,
          style: TextStyle(
            color: Colors.white,
            fontSize: isMobile ? 28 : 38,
            fontWeight: FontWeight.bold,
            height: 1.15,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          crossAxisCount: isMobile ? 2 : 4,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: isMobile ? 1.65 : 1.8,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            _metricCard(
              'Lesson Progress',
              '${content.progress}%',
              Icons.track_changes_rounded,
              AppColors.brand300,
              progress: content.progress / 100,
            ),
            _metricCard(
              'Estimated Time',
              content.estimatedTime,
              Icons.schedule_rounded,
              AppColors.brand300,
            ),
            _metricCard(
              'Difficulty',
              content.difficulty,
              Icons.signal_cellular_alt_rounded,
              AppColors.brand300,
            ),
            _metricCard(
              'XP Reward',
              '+${content.xpReward} XP',
              Icons.auto_awesome_rounded,
              Colors.amber,
            ),
          ],
        ),
      ],
    );
  }

  Widget _metricCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    double? progress,
  }) {
    return GlassCard(
      padding: const EdgeInsets.all(14),
      borderRadius: 14,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: color),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 7),
          Text(
            value,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: color == Colors.amber ? Colors.white : color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          if (progress != null) ...[
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 5,
                backgroundColor: Colors.white10,
                color: AppColors.brand300,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildExplanation(LessonContent content, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.menu_book_rounded,
            title: 'Explanation',
          ),
          const SizedBox(height: 14),
          ...content.explanation.map(
            (paragraph) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                paragraph,
                style: const TextStyle(
                  color: AppColors.textMain,
                  fontSize: 14,
                  height: 1.55,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVocabulary(LessonContent content, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.translate_rounded,
            title: 'Vocabulary List',
          ),
          const SizedBox(height: 12),
          ...content.vocabulary.asMap().entries.map(
            (entry) => Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: entry.key == content.vocabulary.length - 1
                    ? null
                    : const Border(
                        bottom: BorderSide(color: Color(0x1AFFFFFF)),
                      ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 3,
                    child: Text(
                      entry.value.term,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.value.reading,
                      style: const TextStyle(
                        color: AppColors.brand300,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      entry.value.meaning,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPronunciation(LessonContent content, bool isMobile) {
    return GlassCard(
      padding: EdgeInsets.all(isMobile ? 18 : 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _SectionTitle(
            icon: Icons.record_voice_over_rounded,
            title: 'Pronunciation & Examples',
          ),
          const SizedBox(height: 12),
          ...content.examples.map(
            (example) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.04),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.08),
                  ),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            example.text,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            example.reading,
                            style: const TextStyle(
                              color: AppColors.brand300,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            example.meaning,
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    TextButton.icon(
                      onPressed: () => _speechService.playAudio(
                        example.text,
                        languageId: content.languageCode,
                      ),
                      icon: const Icon(Icons.volume_up_rounded, size: 17),
                      label: const Text('Listen'),
                      style: TextButton.styleFrom(
                        foregroundColor: AppColors.brand300,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLessonActions(
    BuildContext context,
    LessonContent content,
    bool isMobile,
  ) {
    final back = GlassButton(
      onPressed: () => context.go('/language/${content.languageCode}/study'),
      variant: GlassButtonVariant.glass,
      child: const Text('Back to Study'),
    );
    final complete = GlassButton(
      onPressed: () {
        if (_isCompleted) return; // prevent double-award
        setState(() => _isCompleted = true);
        // Award XP to the language and global total
        context
            .read<AppState>()
            .addLanguageXp(content.languageCode, content.xpReward);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lesson Completed! +${content.xpReward} XP Earned!'),
          ),
        );
      },
      variant: _isCompleted
          ? GlassButtonVariant.glass
          : GlassButtonVariant.primary,
      icon: Icon(
        _isCompleted ? Icons.check_circle_rounded : Icons.star_rounded,
        color: Colors.white,
      ),
      child: Text(_isCompleted ? 'Completed' : 'Mark as Complete'),
    );
    if (isMobile) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [back, const SizedBox(height: 10), complete],
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [back, complete],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.icon, required this.title});
  final IconData icon;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: AppColors.brand300, size: 20),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
