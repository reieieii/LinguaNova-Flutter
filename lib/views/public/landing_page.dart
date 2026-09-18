import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../presentation/app_state.dart';
import '../../presentation/widgets/glass_card.dart';
import '../../presentation/widgets/glass_button.dart';
import 'widgets/features_section.dart';
import 'widgets/hero_section.dart';
import 'widgets/landing_navbar.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({
    super.key,
    required this.onNavigateToAuth,
  });

  final VoidCallback onNavigateToAuth;

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _featuresKey = GlobalKey();
  final GlobalKey _languagesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _communityKey = GlobalKey();

  void _scrollToSection(String section) {
    GlobalKey? targetKey;
    switch (section) {
      case 'features':
        targetKey = _featuresKey;
        break;
      case 'languages':
        targetKey = _languagesKey;
        break;
      case 'pricing':
        targetKey = _pricingKey;
        break;
      case 'community':
        targetKey = _communityKey;
        break;
      case 'hero':
        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOut,
        );
        return;
    }

    if (targetKey?.currentContext != null) {
      Scrollable.ensureVisible(
        targetKey!.currentContext!,
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final isLoggedIn = state.currentUser != null;

    return Scaffold(
      backgroundColor: AppColors.dark900,
      body: Stack(
        children: [
          // Background Ambient Glow Orbs
          Positioned(
            top: -100,
            left: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brand700.withValues(alpha: 0.25),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -100,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppColors.brand500.withValues(alpha: 0.20),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),

          // Main Scrollable Content
          SingleChildScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(),
            child: Column(
              children: [
                const SizedBox(height: 80), // Offset for navbar

                // Hero Section
                HeroSection(
                  onStartLearning: widget.onNavigateToAuth,
                  onWatchDemo: () => _scrollToSection('features'),
                ),

                // Features Section
                Container(
                  key: _featuresKey,
                  child: const FeaturesSection(),
                ),

                // Languages Section
                Container(
                  key: _languagesKey,
                  child: _LanguagesSection(onSelectLanguage: widget.onNavigateToAuth),
                ),

                // Pricing Section
                Container(
                  key: _pricingKey,
                  child: _PricingSection(onSelectPlan: widget.onNavigateToAuth),
                ),

                // Community Section
                Container(
                  key: _communityKey,
                  child: _CommunitySection(onJoin: widget.onNavigateToAuth),
                ),

                // Footer
                const _Footer(),
              ],
            ),
          ),

          // Top Navbar (Fixed position)
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: LandingNavbar(
              onNavigateAuth: widget.onNavigateToAuth,
              onNavigateSection: _scrollToSection,
              isLoggedIn: isLoggedIn,
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguagesSection extends StatelessWidget {
  const _LanguagesSection({required this.onSelectLanguage});
  final VoidCallback onSelectLanguage;

  static const _languages = [
    {
      'name': 'Japanese',
      'flag': '🇯🇵',
      'desc': 'Master Kanji, Hiragana, and Katakana.',
      'diff': 'Hard',
      'hours': '2200h'
    },
    {
      'name': 'Chinese',
      'flag': '🇨🇳',
      'desc': 'Learn Mandarin, Pinyin, and Hanzi.',
      'diff': 'Hard',
      'hours': '2200h'
    },
    {
      'name': 'Korean',
      'flag': '🇰🇷',
      'desc': 'Read Hangul and learn grammar naturally.',
      'diff': 'Medium',
      'hours': '1200h'
    },
    {
      'name': 'English',
      'flag': '🇺🇸',
      'desc': 'Perfect your pronunciation and idioms.',
      'diff': 'Easy',
      'hours': '600h'
    },
    {
      'name': 'Spanish',
      'flag': '🇪🇸',
      'desc': 'Converse fluently in real-life situations.',
      'diff': 'Easy',
      'hours': '600h'
    },
  ];

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
              const Text(
                'Available Languages',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  shadows: [
                    Shadow(color: Color(0x40FFFFFF), blurRadius: 20),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Choose a language and start your journey today.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 64),
              LayoutBuilder(
                builder: (context, constraints) {
                  final crossAxisCount = isMobile ? 1 : (screenWidth > 1100 ? 3 : 2);
                  return GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: crossAxisCount,
                      crossAxisSpacing: 24,
                      mainAxisSpacing: 24,
                      childAspectRatio: isMobile ? 1.0 : 0.85,
                    ),
                    itemCount: _languages.length,
                    itemBuilder: (context, index) {
                      final lang = _languages[index];
                      return InkWell(
                        onTap: onSelectLanguage,
                        borderRadius: BorderRadius.circular(16),
                        child: GlassCard(
                          padding: const EdgeInsets.all(28),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                lang['flag']!,
                                style: const TextStyle(fontSize: 48),
                              ),
                              const SizedBox(height: 16),
                              Text(
                                lang['name']!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                lang['desc']!,
                                style: const TextStyle(
                                  color: AppColors.textMuted,
                                  fontSize: 14,
                                  height: 1.5,
                                ),
                              ),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: AppColors.brand500.withValues(alpha: 0.15),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      lang['diff']!,
                                      style: const TextStyle(
                                        color: AppColors.brand300,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w600,
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
      ),
    );
  }
}

class _PricingSection extends StatelessWidget {
  const _PricingSection({required this.onSelectPlan});
  final VoidCallback onSelectPlan;

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final isMobile = screenWidth < 850;

    return Container(
      color: AppColors.dark900.withValues(alpha: 0.5),
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              const Text(
                'Simple, transparent pricing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Unlock your full potential.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.textMuted,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 64),
              Flex(
                direction: isMobile ? Axis.vertical : Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment:
                    isMobile ? CrossAxisAlignment.stretch : CrossAxisAlignment.center,
                children: [
                  _pricingCard(
                    title: 'Free',
                    price: '\$0',
                    period: '/forever',
                    features: [
                      'Basic vocabulary',
                      '10 AI conversations/month',
                      'Community access'
                    ],
                    buttonText: 'Start Free',
                    variant: GlassButtonVariant.glass,
                    isPopular: false,
                  ),
                  SizedBox(width: isMobile ? 0 : 24, height: isMobile ? 24 : 0),
                  _pricingCard(
                    title: 'Premium',
                    price: '\$9.99',
                    period: '/month',
                    features: [
                      'Unlimited AI conversations',
                      'Advanced grammar',
                      'Smart flashcards',
                      'Priority support'
                    ],
                    buttonText: 'Subscribe Premium',
                    variant: GlassButtonVariant.primary,
                    isPopular: true,
                  ),
                  SizedBox(width: isMobile ? 0 : 24, height: isMobile ? 24 : 0),
                  _pricingCard(
                    title: 'Pro',
                    price: '\$19.99',
                    period: '/month',
                    features: [
                      'All Premium features',
                      '1-on-1 Native tutoring (1hr/mo)',
                      'Certification prep'
                    ],
                    buttonText: 'Subscribe Pro',
                    variant: GlassButtonVariant.glass,
                    isPopular: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _pricingCard({
    required String title,
    required String price,
    required String period,
    required List<String> features,
    required String buttonText,
    required GlassButtonVariant variant,
    required bool isPopular,
  }) {
    return Container(
      width: 340,
      margin: EdgeInsets.only(top: isPopular ? 0 : 16),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          GlassCard(
            borderColor: isPopular ? AppColors.brand500 : null,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        period,
                        style: const TextStyle(
                          color: AppColors.textMuted,
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  ...features.map((f) => Padding(
                        padding: const EdgeInsets.only(bottom: 12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline_rounded,
                              size: 18,
                              color: AppColors.brand300,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                f,
                                style: const TextStyle(
                                  color: AppColors.textMain,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )),
                  const SizedBox(height: 24),
                  GlassButton(
                    onPressed: onSelectPlan,
                    variant: variant,
                    fullWidth: true,
                    child: Text(buttonText),
                  ),
                ],
              ),
            ),
          ),
          if (isPopular)
            Positioned(
              top: -14,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.brand500,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [
                      BoxShadow(
                        color: AppColors.glowColor,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Text(
                    'MOST POPULAR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _CommunitySection extends StatelessWidget {
  const _CommunitySection({required this.onJoin});
  final VoidCallback onJoin;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 96, horizontal: 24),
      width: double.infinity,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: GlassCard(
            padding: const EdgeInsets.all(48),
            child: Column(
              children: [
                const Icon(
                  Icons.groups_rounded,
                  size: 56,
                  color: AppColors.brand300,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Join a Global Community',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Connect with over 50,000 language learners worldwide. Practice together, share tips, and achieve fluency faster.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 32),
                GlassButton(
                  onPressed: onJoin,
                  variant: GlassButtonVariant.primary,
                  isLarge: true,
                  child: const Text('Join Community Now'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 24),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.glassBorder)),
      ),
      child: Center(
        child: Column(
          children: [
            const Text(
              'LinguaNova — Nova Language Learning',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '© ${DateTime.now().year} Kelompok Lunavera, SMKN 20 Jakarta. All rights reserved.',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
