import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class QuizQuestion {
  const QuizQuestion(this.prompt, this.answer, this.choices);
  final String prompt;
  final String answer;
  final List<String> choices;
}

class LanguageQuizPage extends StatefulWidget {
  const LanguageQuizPage({super.key, required this.languageId});
  final String languageId;

  @override
  State<LanguageQuizPage> createState() => _LanguageQuizPageState();
}

class _LanguageQuizPageState extends State<LanguageQuizPage> {
  final SpeechService _speechService = SpeechService();
  int _index = 0;
  int _correct = 0;
  String? _selected;
  bool _answered = false;
  bool _finished = false;
  int _earnedXp = 0; // XP awarded at the end of this session

  static const Map<String, List<QuizQuestion>> _questions = {
    'japanese': [
      QuizQuestion('あ', 'a', ['a', 'i', 'u', 'e']),
      QuizQuestion('か', 'ka', ['ka', 'ki', 'ku', 'ke']),
      QuizQuestion('こんにちは', 'Konnichiwa', [
        'Konnichiwa',
        'Sayounara',
        'Arigatou',
        'Sumimasen',
      ]),
      QuizQuestion('ありがとう', 'Arigatou', [
        'Sumimasen',
        'Sayounara',
        'Arigatou',
        'Konnichiwa',
      ]),
      QuizQuestion('さようなら', 'Sayounara', [
        'Ohayou',
        'Sayounara',
        'Onegaishimasu',
        'Konnichiwa',
      ]),
    ],
    'english': [
      QuizQuestion('Hello', 'Greeting', [
        'Greeting',
        'Food',
        'Number',
        'Color',
      ]),
      QuizQuestion('Thank you', 'Gratitude', [
        'Apology',
        'Gratitude',
        'Farewell',
        'Question',
      ]),
      QuizQuestion('Goodbye', 'Farewell', [
        'Greeting',
        'Farewell',
        'Thanks',
        'Name',
      ]),
      QuizQuestion('A, E, I, O, U', 'Vowels', [
        'Numbers',
        'Vowels',
        'Consonants',
        'Tones',
      ]),
      QuizQuestion('Sorry', 'Apology', [
        'Apology',
        'Greeting',
        'Farewell',
        'Direction',
      ]),
    ],
    'chinese': [
      QuizQuestion('你好', 'nǐ hǎo', [
        'nǐ hǎo',
        'xiè xie',
        'zài jiàn',
        'duì bù qǐ',
      ]),
      QuizQuestion('谢谢', 'xiè xie', [
        'zài jiàn',
        'nǐ hǎo',
        'xiè xie',
        'duì bù qǐ',
      ]),
      QuizQuestion('再见', 'zài jiàn', [
        'nǐ hǎo',
        'zài jiàn',
        'duì bù qǐ',
        'xiè xie',
      ]),
      QuizQuestion('一声', 'yī shēng', [
        'yī shēng',
        'èr shēng',
        'sān shēng',
        'sì shēng',
      ]),
      QuizQuestion('对不起', 'duì bù qǐ', [
        'nǐ hǎo',
        'xiè xie',
        'duì bù qǐ',
        'zài jiàn',
      ]),
    ],
    'spanish': [
      QuizQuestion('Hola', 'Hola', ['Hola', 'Adiós', 'Por favor', 'Gracias']),
      QuizQuestion('Gracias', 'Gracias', [
        'Lo siento',
        'Gracias',
        'Hola',
        'Adiós',
      ]),
      QuizQuestion('Adiós', 'Adiós', [
        'Adiós',
        'Hola',
        'Por favor',
        'Gracias',
      ]),
      QuizQuestion('Por favor', 'Por favor', [
        'Lo siento',
        'Por favor',
        'Gracias',
        'Buenos días',
      ]),
      QuizQuestion('Lo siento', 'Lo siento', [
        'Hola',
        'Adiós',
        'Lo siento',
        'Gracias',
      ]),
    ],
    'korean': [
      QuizQuestion('안녕하세요', 'Annyeonghaseyo', [
        'Annyeonghaseyo',
        'Annyeonghi gaseyo',
        'Mianhamnida',
        'Gamsahamnida',
      ]),
      QuizQuestion('감사합니다', 'Gamsahamnida', [
        'Juseyo',
        'Gamsahamnida',
        'Annyeonghaseyo',
        'Annyeonghi gaseyo',
      ]),
      QuizQuestion('ㄱ', 'g/k', ['g/k', 'n', 'd/t', 'm']),
      QuizQuestion('ㅏ', 'a', ['o', 'a', 'u', 'i']),
      QuizQuestion('안녕히 가세요', 'Annyeonghi gaseyo', [
        'Annyeonghaseyo',
        'Gamsahamnida',
        'Annyeonghi gaseyo',
        'Mianhamnida',
      ]),
    ],
  };

  List<QuizQuestion> get _currentQuestions =>
      _questions[widget.languageId.toLowerCase()] ?? _questions['japanese']!;

  String get _languageName {
    final name = widget.languageId.toLowerCase();
    return name[0].toUpperCase() + name.substring(1);
  }

  void _selectAnswer(String choice) {
    if (_answered) return;
    final question = _currentQuestions[_index];
    final correct = choice == question.answer;
    setState(() {
      _selected = choice;
      _answered = true;
      if (correct) _correct++;
    });
    _speechService.speak(question.prompt, languageId: widget.languageId);

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      if (_index == _currentQuestions.length - 1) {
        // Award 10 XP per correct answer
        final xp = _correct * 10;
        setState(() {
          _finished = true;
          _earnedXp = xp;
        });
        if (xp > 0) {
          context.read<AppState>().addLanguageXp(widget.languageId, xp);
        }
      } else {
        setState(() {
          _index++;
          _selected = null;
          _answered = false;
        });
      }
    });
  }

  void _restart() {
    setState(() {
      _index = 0;
      _correct = 0;
      _selected = null;
      _answered = false;
      _finished = false;
      _earnedXp = 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final questions = _currentQuestions;
    if (_finished) return _buildSummary(context, questions.length);
    final question = questions[_index];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton.icon(
                    onPressed: () =>
                        context.go('/language/${widget.languageId}/practice'),
                    icon: const Icon(Icons.arrow_back_rounded),
                    label: const Text('Practice Hub'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.textMuted,
                    ),
                  ),
                  Text(
                    'Question ${_index + 1} / ${questions.length}',
                    style: const TextStyle(
                      color: AppColors.brand300,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              LinearProgressIndicator(
                value: (_index + 1) / questions.length,
                minHeight: 8,
                borderRadius: BorderRadius.circular(8),
                color: AppColors.brand300,
                backgroundColor: Colors.white10,
              ),
              const SizedBox(height: 24),
              GlassCard(
                padding: const EdgeInsets.all(28),
                child: Column(
                  children: [
                    Text(
                      '$_languageName Practice',
                      style: const TextStyle(
                        color: AppColors.brand300,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      question.prompt,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 52,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      onPressed: () => _speechService.speak(
                        question.prompt,
                        languageId: widget.languageId,
                      ),
                      icon: const Icon(
                        Icons.volume_up_rounded,
                        color: AppColors.brand300,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 20),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: question.choices.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 2.4,
                          ),
                      itemBuilder: (context, index) {
                        final choice = question.choices[index];
                        final isCorrect = choice == question.answer;
                        final isSelected = choice == _selected;
                        Color color = Colors.white.withValues(alpha: 0.05);
                        Color border = Colors.white.withValues(alpha: 0.15);
                        IconData? icon;
                        if (_answered && isCorrect) {
                          color = Colors.green.withValues(alpha: 0.25);
                          border = Colors.greenAccent;
                          icon = Icons.check_rounded;
                        } else if (_answered && isSelected) {
                          color = Colors.red.withValues(alpha: 0.25);
                          border = Colors.redAccent;
                          icon = Icons.close_rounded;
                        }
                        return InkWell(
                          onTap: () => _selectAnswer(choice),
                          borderRadius: BorderRadius.circular(14),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            decoration: BoxDecoration(
                              color: color,
                              border: Border.all(color: border, width: 1.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Flexible(
                                  child: Text(
                                    choice,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                if (icon != null) ...[
                                  const SizedBox(width: 6),
                                  Icon(icon, color: Colors.white, size: 20),
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, int total) {
    final incorrect = total - _correct;
    final isPerfect = _correct == total;
    final scoreColor = isPerfect
        ? Colors.greenAccent
        : _correct >= total ~/ 2
            ? AppColors.brand300
            : Colors.redAccent;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: GlassCard(
            padding: const EdgeInsets.all(36),
            child: Column(
              children: [
                // Trophy icon — gold if perfect, silver otherwise
                Icon(
                  Icons.emoji_events_rounded,
                  color: isPerfect ? Colors.amber : Colors.blueGrey,
                  size: 70,
                ),
                const SizedBox(height: 16),
                const Text(
                  'Practice Session Completed!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '$_languageName quiz finished',
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 24),

                // Score
                Text(
                  'Score: $_correct / $total Correct',
                  style: TextStyle(
                    color: scoreColor,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Correct: $_correct    Incorrect: $incorrect',
                  style: const TextStyle(
                    color: AppColors.textMain,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 22),

                // XP reward banner
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                      vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.amber.withValues(alpha: 0.18),
                        AppColors.brand700.withValues(alpha: 0.25),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                        color: Colors.amber.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text('⚡', style: TextStyle(fontSize: 22)),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '+$_earnedXp XP Earned',
                            style: const TextStyle(
                              color: Colors.amber,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            '$_correct correct answer${_correct == 1 ? '' : 's'} × 10 XP',
                            style: const TextStyle(
                              color: AppColors.textMuted,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 28),

                // Action buttons
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    GlassButton(
                      onPressed: () => context.go('/practice'),
                      variant: GlassButtonVariant.glass,
                      child: const Text('Back to Practice'),
                    ),
                    GlassButton(
                      onPressed: _restart,
                      variant: GlassButtonVariant.primary,
                      child: const Text('Play Again'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
