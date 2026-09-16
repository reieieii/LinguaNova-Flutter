import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/floating_character_widget.dart';
import '../../../presentation/widgets/glass_button.dart';
import '../../../presentation/widgets/gradient_text.dart';

class HeroSection extends StatelessWidget {
  const HeroSection({
    super.key,
    required this.onStartLearning,
    required this.onWatchDemo,
  });

  final VoidCallback onStartLearning;
  final VoidCallback onWatchDemo;

  static const List<_CharConfig> _chars = [
    _CharConfig(char: '学', delay: 0.0, xRatio: 0.08, yRatio: 0.15, size: 76),
    _CharConfig(char: '愛', delay: 1.0, xRatio: 0.82, yRatio: 0.12, size: 92),
    _CharConfig(char: '梦', delay: 2.0, xRatio: 0.06, yRatio: 0.62, size: 68),
    _CharConfig(char: '한', delay: 0.5, xRatio: 0.86, yRatio: 0.68, size: 84),
    _CharConfig(char: '글', delay: 1.5, xRatio: 0.72, yRatio: 0.28, size: 58),
    _CharConfig(char: '星', delay: 2.5, xRatio: 0.20, yRatio: 0.76, size: 78),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    final isMobile = screenWidth < 640;

    return Container(
      constraints: BoxConstraints(
        minHeight: screenHeight * 0.85,
      ),
      width: double.infinity,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Floating background characters
          ..._chars.map((c) {
            final xPos = screenWidth * c.xRatio;
            final yPos = (screenHeight * 0.85) * c.yRatio;
            return Positioned(
              left: xPos,
              top: yPos,
              child: FloatingCharacterWidget(
                char: c.char,
                size: isMobile ? c.size * 0.7 : c.size,
                delay: c.delay,
              ),
            );
          }),

          // Hero Central Content
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 800),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Badge Pill
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.brand500.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(30),
                        border: Border.all(
                          color: AppColors.brand500.withValues(alpha: 0.2),
                          width: 1,
                        ),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.auto_awesome_rounded,
                            size: 16,
                            color: AppColors.brand300,
                          ),
                          SizedBox(width: 8),
                          Text(
                            'AI-Powered Language Learning',
                            style: TextStyle(
                              color: AppColors.brand300,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 28),

                    // Main Headline
                    RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        style: TextStyle(
                          fontSize: isMobile ? 38 : 64,
                          fontWeight: FontWeight.w800,
                          height: 1.1,
                          letterSpacing: -1,
                          fontFamily: 'Inter',
                        ),
                        children: [
                          const TextSpan(
                            text: 'Master Languages\n',
                            style: TextStyle(color: Colors.white),
                          ),
                          WidgetSpan(
                            child: GradientText(
                              'Beautifully.',
                              style: TextStyle(
                                fontSize: isMobile ? 38 : 64,
                                fontWeight: FontWeight.w800,
                                height: 1.1,
                                letterSpacing: -1,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Subtitle Description
                    Text(
                      'Learn Japanese, Chinese, Korean, English and Spanish using AI conversations, flashcards, grammar lessons and pronunciation practice.',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textMain.withValues(alpha: 0.8),
                        fontSize: isMobile ? 16 : 20,
                        height: 1.6,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Call to Action Buttons
                    Flex(
                      direction: isMobile ? Axis.vertical : Axis.horizontal,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        GlassButton(
                          onPressed: onStartLearning,
                          variant: GlassButtonVariant.primary,
                          isLarge: true,
                          fullWidth: isMobile,
                          child: const Text('Start Learning'),
                        ),
                        SizedBox(
                          width: isMobile ? 0 : 16,
                          height: isMobile ? 12 : 0,
                        ),
                        GlassButton(
                          onPressed: onWatchDemo,
                          variant: GlassButtonVariant.glass,
                          isLarge: true,
                          fullWidth: isMobile,
                          icon: const Icon(
                            Icons.play_circle_outline_rounded,
                            size: 20,
                            color: AppColors.brand300,
                          ),
                          child: const Text('Watch Demo'),
                        ),
                      ],
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
}

class _CharConfig {
  const _CharConfig({
    required this.char,
    required this.delay,
    required this.xRatio,
    required this.yRatio,
    required this.size,
  });

  final String char;
  final double delay;
  final double xRatio;
  final double yRatio;
  final double size;
}
