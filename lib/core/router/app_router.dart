import 'package:go_router/go_router.dart';
import '../../pages/dashboard/achievements_page.dart';
import '../../pages/dashboard/calendar_page.dart';
import '../../pages/dashboard/dashboard_main_page.dart';
import '../../pages/dashboard/languages_page.dart';
import '../../pages/dashboard/profile_page.dart';
import '../../pages/dashboard/progress_page.dart';
import '../../pages/dashboard/settings_page.dart';
import '../../pages/dashboard/vocabulary_page.dart';
import '../../pages/language/hiragana_quiz_page.dart';
import '../../pages/language/japanese_chart_page.dart';
import '../../pages/language/language_hub_page.dart';
import '../../pages/language/language_lesson_page.dart';
import '../../pages/language/language_practice_page.dart';
import '../../pages/language/language_quiz_page.dart';
import '../../pages/language/language_study_page.dart';
import '../../pages/navigation/dashboard_layout.dart';
import '../../views/auth/auth_page.dart';
import '../../views/public/landing_page.dart';

class AppRouter {
  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      // Public Landing Page
      GoRoute(
        path: '/',
        builder: (context, state) =>
            LandingPage(onNavigateToAuth: () => context.go('/login')),
      ),

      // Auth Page (Login / Register)
      GoRoute(path: '/login', builder: (context, state) => const AuthPage()),
      GoRoute(path: '/register', builder: (context, state) => const AuthPage()),

      // Dashboard Routes wrapped in Acrylic Glass DashboardLayout
      GoRoute(
        path: '/dashboard',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/dashboard',
          child: DashboardMainPage(),
        ),
      ),
      GoRoute(
        path: '/practice',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/practice',
          child: LanguagePracticePage(languageId: 'japanese'),
        ),
      ),
      GoRoute(
        path: '/languages',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/languages',
          child: LanguagesPage(),
        ),
      ),
      GoRoute(
        path: '/vocabulary',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/vocabulary',
          child: VocabularyPage(),
        ),
      ),
      GoRoute(
        path: '/achievements',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/achievements',
          child: AchievementsPage(),
        ),
      ),
      GoRoute(
        path: '/progress',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/progress',
          child: ProgressPage(),
        ),
      ),
      GoRoute(
        path: '/calendar',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/calendar',
          child: CalendarPage(),
        ),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/settings',
          child: SettingsPage(),
        ),
      ),
      GoRoute(
        path: '/profile',
        builder: (context, state) => const DashboardLayout(
          currentRoute: '/profile',
          child: ProfilePage(),
        ),
      ),

      // Language Module Dynamic Routes
      GoRoute(
        path: '/language/:lang',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/languages',
            child: LanguageHubPage(languageId: lang),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/study',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/languages',
            child: LanguageStudyPage(languageId: lang),
          );
        },
      ),
      // Japanese Kana chart pages — MUST be declared BEFORE the :lesson wildcard
      GoRoute(
        path: '/language/:lang/study/hiragana-chart',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/languages',
            child: JapaneseChartPage(languageId: lang, chartType: 'hiragana'),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/study/katakana-chart',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/languages',
            child: JapaneseChartPage(languageId: lang, chartType: 'katakana'),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/study/:lesson',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          final lesson = state.pathParameters['lesson'] ?? 'lesson-1';
          return DashboardLayout(
            currentRoute: '/languages',
            child: LanguageLessonPage(languageId: lang, lessonId: lesson),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/practice',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/practice',
            child: LanguagePracticePage(languageId: lang),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/practice/hiragana',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/practice',
            child: HiraganaQuizPage(languageId: lang),
          );
        },
      ),
      GoRoute(
        path: '/language/:lang/practice/quiz',
        builder: (context, state) {
          final lang = state.pathParameters['lang'] ?? 'japanese';
          return DashboardLayout(
            currentRoute: '/practice',
            child: LanguageQuizPage(languageId: lang),
          );
        },
      ),
    ],
  );
}
