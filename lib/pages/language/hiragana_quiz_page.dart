import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/services/speech_service.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_button.dart';
import '../../presentation/widgets/glass_card.dart';

class HiraganaQuizPage extends StatefulWidget {
  const HiraganaQuizPage({
    super.key,
    required this.languageId,
  });

  final String languageId;

  @override
  State<HiraganaQuizPage> createState() => _HiraganaQuizPageState();
}

class _HiraganaQuizPageState extends State<HiraganaQuizPage> {
  final SpeechService _speechService = SpeechService();

  static const List<Map<String, dynamic>> _allQuestions = [
    {
      'question': 'あ',
      'answer': 'a',
      'choices': ['a', 'i', 'u', 'e']
    },
    {
      'question': 'い',
      'answer': 'i',
      'choices': ['o', 'i', 'ka', 'a']
    },
    {
      'question': 'う',
      'answer': 'u',
      'choices': ['u', 'e', 'ko', 'sa']
    },
    {
      'question': 'え',
      'answer': 'e',
      'choices': ['a', 'e', 'i', 'su']
    },
    {
      'question': 'お',
      'answer': 'o',
      'choices': ['o', 'u', 'ta', 'ne']
    },
    {
      'question': 'か',
      'answer': 'ka',
      'choices': ['ka', 'ki', 'ku', 'ke']
    },
    {
      'question': 'き',
      'answer': 'ki',
      'choices': ['sa', 'ki', 'ko', 'na']
    },
    {
      'question': 'く',
      'answer': 'ku',
      'choices': ['ma', 'ku', 'ru', 'te']
    },
  ];

  int _currentIndex = 0;
  int _score = 0;
  String? _selectedChoice;
  bool _showFeedback = false;
  bool _isQuizFinished = false;

  void _handleChoice(String choice) {
    if (_showFeedback) return;

    final currentQuestion = _allQuestions[_currentIndex];
    final bool isCorrect = choice == currentQuestion['answer'];

    setState(() {
      _selectedChoice = choice;
      _showFeedback = true;
      if (isCorrect) {
        _score += 10;
        // Speak pronunciation
        _speechService.speak(currentQuestion['question'] as String, languageId: widget.languageId);
      }
    });

    Future.delayed(const Duration(milliseconds: 1100), () {
      if (!mounted) return;
      if (_currentIndex < _allQuestions.length - 1) {
        setState(() {
          _currentIndex++;
          _selectedChoice = null;
          _showFeedback = false;
        });
      } else {
        setState(() {
          _isQuizFinished = true;
        });
        // Award XP: _score already accumulated 10 XP per correct answer
        if (_score > 0) {
          context.read<AppState>().addLanguageXp(widget.languageId, _score);
        }
      }
    });
  }

  void _restartQuiz() {
    setState(() {
      _currentIndex = 0;
      _score = 0;
      _selectedChoice = null;
      _showFeedback = false;
      _isQuizFinished = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final langKey = widget.languageId.toLowerCase();

    if (_isQuizFinished) {
      return Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: GlassCard(
              padding: const EdgeInsets.all(36),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('🎉', style: TextStyle(fontSize: 64)),
                  const SizedBox(height: 16),
                  const Text(
                    'Quiz Completed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Final Score: $_score XP',
                    style: const TextStyle(
                      color: AppColors.brand300,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GlassButton(
                        onPressed: () => context.go('/language/$langKey/practice'),
                        variant: GlassButtonVariant.glass,
                        child: const Text('Back to Practice'),
                      ),
                      const SizedBox(width: 16),
                      GlassButton(
                        onPressed: _restartQuiz,
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

    final q = _allQuestions[_currentIndex];
    final choices = q['choices'] as List<String>;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 650),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () => context.go('/language/$langKey/practice'),
                    child: const Row(
                      children: [
                        Icon(Icons.arrow_back_rounded, color: AppColors.textMuted, size: 18),
                        SizedBox(width: 6),
                        Text('Exit Quiz', style: TextStyle(color: AppColors.textMuted, fontSize: 14)),
                      ],
                    ),
                  ),
                  Text(
                    'Question ${_currentIndex + 1} / ${_allQuestions.length}',
                    style: const TextStyle(color: AppColors.brand300, fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: (_currentIndex + 1) / _allQuestions.length,
                  minHeight: 8,
                  backgroundColor: Colors.white10,
                  color: AppColors.brand300,
                ),
              ),
              const SizedBox(height: 32),

              // Question Glass Card
              GlassCard(
                padding: const EdgeInsets.all(36),
                child: Column(
                  children: [
                    Text(
                      q['question'] as String,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 96,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.volume_up_rounded, color: AppColors.brand300, size: 32),
                      onPressed: () {
                        _speechService.speak(q['question'] as String, languageId: langKey);
                      },
                    ),
                    const SizedBox(height: 32),

                    // Option Buttons Grid
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 2.5,
                      ),
                      itemCount: choices.length,
                      itemBuilder: (context, idx) {
                        final choice = choices[idx];
                        final isSelected = choice == _selectedChoice;
                        final isCorrect = choice == q['answer'];

                        Color btnColor = Colors.white.withValues(alpha: 0.05);
                        Color borderColor = Colors.white.withValues(alpha: 0.15);

                        if (_showFeedback) {
                          if (isCorrect) {
                            btnColor = Colors.green.withValues(alpha: 0.25);
                            borderColor = Colors.greenAccent;
                          } else if (isSelected) {
                            btnColor = Colors.red.withValues(alpha: 0.25);
                            borderColor = Colors.redAccent;
                          }
                        }

                        return InkWell(
                          onTap: () => _handleChoice(choice),
                          borderRadius: BorderRadius.circular(16),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            decoration: BoxDecoration(
                              color: btnColor,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: borderColor, width: 1.5),
                            ),
                            child: Center(
                              child: Text(
                                choice,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
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
}
