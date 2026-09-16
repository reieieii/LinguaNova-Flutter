import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../presentation/widgets/glass_card.dart';

class FeaturesSection extends StatelessWidget {
  const FeaturesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 768;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              // Section Title & Subtitle
              const Text(
                'Everything you need to become fluent',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'A complete toolset designed for rapid acquisition.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 64),

              // Feature Cards Layout
              if (isMobile)
                Column(
                  children: _buildFeatureCards(),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildFeatureCards()
                      .map((card) => Expanded(child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: card,
                          )))
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFeatureCards() {
    return [
      const _FeatureCard(
        icon: Icons.psychology_rounded,
        title: 'AI Conversations',
        description:
            'Practice real scenarios with an intelligent tutor that adapts to your level and corrects mistakes.',
      ),
      const SizedBox(height: 24),
      const _FeatureCard(
        icon: Icons.auto_stories_rounded,
        title: 'Smart Flashcards',
        description:
            'Spaced repetition system ensures you never forget the vocabulary you\'ve learned.',
      ),
      const SizedBox(height: 24),
      const _FeatureCard(
        icon: Icons.language_rounded,
        title: 'Native Context',
        description:
            'Learn grammar and nuances through real-world examples from native speakers.',
      ),
    ];
  }
}

class _FeatureCard extends StatefulWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  State<_FeatureCard> createState() => _FeatureCardState();
}

class _FeatureCardState extends State<_FeatureCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        transform: Matrix4.translationValues(0, _isHovered ? -6 : 0, 0),
        child: GlassCard(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon container
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: AppColors.brand500.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.brand500.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Icon(
                  widget.icon,
                  size: 32,
                  color: AppColors.brand300,
                ),
              ),
              const SizedBox(height: 24),

              // Title
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              // Description
              Text(
                widget.description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted.withValues(alpha: 0.9),
                  fontSize: 15,
                  height: 1.6,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
