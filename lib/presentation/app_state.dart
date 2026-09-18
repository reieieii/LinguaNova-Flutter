import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/learning_repository.dart';
import '../models/app_models.dart';

class AppState extends ChangeNotifier {
  AppState(this.authRepository, this.learningRepository);
  final AuthRepository authRepository;
  final LearningRepository learningRepository;
  AppUser? currentUser;
  bool isLoading = true;
  String? errorMessage;
  String? registrationMessage;
  UserStreak streak = const UserStreak(count: 5, lastActivityDate: null);

  // ── XP & Level ────────────────────────────────────────────────────────────
  int totalXp = 0;

  /// Per-language XP map — key: lowercase language name (e.g. 'japanese').
  Map<String, int> languageXp = {};

  /// XP needed to reach the next level (100 XP per level).
  static const int xpPerLevel = 100;

  /// Current level derived from totalXp (level 1 = 0–99 XP, etc.).
  int get level => (totalXp ~/ xpPerLevel) + 1;

  /// Progress within the current level, 0.0 – 1.0.
  double get xpLevelProgress => (totalXp % xpPerLevel) / xpPerLevel;

  /// XP accumulated inside the current level (numerator).
  int get xpInLevel => totalXp % xpPerLevel;

  /// XP required to complete the current level (denominator).
  int get xpToNextLevel => xpPerLevel;

  /// XP earned for a specific [languageId] (e.g. 'japanese').
  int getLanguageXpFor(String languageId) =>
      languageXp[languageId.toLowerCase()] ?? 0;

  /// Level for a specific language based on that language's XP alone.
  int getLanguageLevel(String languageId) =>
      (getLanguageXpFor(languageId) ~/ xpPerLevel) + 1;

  Future<void> restoreSession() async {
    try {
      currentUser = await authRepository.restoreSession();
      if (currentUser != null) {
        await _restoreSavedProfileName();
        streak = await learningRepository.getStreak(currentUser!.id);
        totalXp = await learningRepository.getXp(currentUser!.id);
        languageXp =
            await learningRepository.getAllLanguageXp(currentUser!.id);
      }
    } catch (e) {
      debugPrint('restoreSession error: $e');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signIn(String email, String password) async {
    errorMessage = null;
    notifyListeners();
    try {
      currentUser = await authRepository.signIn(email, password);
      streak = await learningRepository.getStreak(currentUser!.id);
      totalXp = await learningRepository.getXp(currentUser!.id);
      languageXp =
          await learningRepository.getAllLanguageXp(currentUser!.id);
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      currentUser = null;
      totalXp = 0;
      languageXp = {};
      notifyListeners();
      return false;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    registrationMessage = null;
    errorMessage = null;
    notifyListeners();
    try {
      final result = await authRepository.register(name, email, password);
      if (result.needsEmailConfirmation) {
        registrationMessage =
            'Akun berhasil dibuat! Silakan cek email Anda untuk mengkonfirmasi akun, lalu login.';
        notifyListeners();
        return false; // false = perlu konfirmasi, bukan error
      }
      currentUser = result.user;
      streak = await learningRepository.getStreak(currentUser!.id);
      notifyListeners();
      return true;
    } catch (error) {
      errorMessage = _friendlyError(error);
      currentUser = null;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } catch (e) {
      debugPrint('signOut error: $e');
    }
    currentUser = null;
    totalXp = 0;
    languageXp = {};
    streak = const UserStreak(count: 0, lastActivityDate: null);
    notifyListeners();
  }

  Future<bool> updateProfile({required String name}) async {
    final updatedName = name.trim().isEmpty ? 'Learner' : name.trim();
    final user =
        currentUser ??
        const AppUser(
          id: 'local_profile',
          email: '',
          name: 'Learner',
          role: UserRole.user,
        );

    currentUser = user.copyWith(name: updatedName);
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(_profileNameKey(user.id), updatedName);
    notifyListeners();
    return true;
  }

  Future<void> _restoreSavedProfileName() async {
    final user = currentUser;
    if (user == null) return;

    final preferences = await SharedPreferences.getInstance();
    final savedName = preferences.getString(_profileNameKey(user.id));
    if (savedName != null) {
      currentUser = user.copyWith(name: savedName);
    }
  }

  String _profileNameKey(String userId) => 'profile_name_$userId';

  /// Awards [amount] XP to the current user, persists to Supabase, and
  /// notifies listeners so the sidebar level bar updates immediately.
  Future<void> addXp(int amount) async {
    if (amount <= 0) return;
    totalXp += amount;
    notifyListeners(); // instant UI update

    final user = currentUser;
    if (user == null) return;
    try {
      await learningRepository.saveXp(user.id, totalXp);
    } catch (e) {
      debugPrint('addXp persist error: $e');
    }
  }

  /// Awards [amount] XP to a specific [languageId] AND to the global total.
  /// Both updates are instant (notifyListeners) then persisted to Supabase.
  Future<void> addLanguageXp(String languageId, int amount) async {
    if (amount <= 0) return;
    final lang = languageId.toLowerCase();

    // Update in-memory state immediately
    languageXp = Map<String, int>.from(languageXp)
      ..[lang] = (languageXp[lang] ?? 0) + amount;
    totalXp += amount;
    notifyListeners();

    final user = currentUser;
    if (user == null) return;
    try {
      await Future.wait([
        learningRepository.saveLanguageXp(user.id, lang, languageXp[lang]!),
        learningRepository.saveXp(user.id, totalXp),
      ]);
    } catch (e) {
      debugPrint('addLanguageXp persist error: $e');
    }
  }

  Future<void> recordLearningActivity() async {    final user = currentUser;
    if (user == null) return;
    final today = _dateOnly(DateTime.now());
    final last = streak.lastActivityDate == null
        ? null
        : _dateOnly(streak.lastActivityDate!);
    if (last == today) return;
    final yesterday = today.subtract(const Duration(days: 1));
    final nextCount = last == null || last == yesterday
        ? (last == null ? 1 : streak.count + 1)
        : streak.count;
    try {
      streak = await learningRepository.saveStreak(
        user.id,
        UserStreak(count: nextCount, lastActivityDate: today),
      );
    } catch (e) {
      streak = UserStreak(count: nextCount, lastActivityDate: today);
    }
    notifyListeners();
  }

  bool get streakActive {
    final last = streak.lastActivityDate;
    if (last == null) return false;
    return _dateOnly(last) == _dateOnly(DateTime.now());
  }

  static DateTime _dateOnly(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  /// Converts a raw Supabase / network error into a user-friendly Indonesian message.
  static String _friendlyError(Object error) {
    final raw = error.toString().toLowerCase();

    // Supabase AuthException messages (English, from Supabase GoTrue)
    if (raw.contains('invalid login credentials') ||
        raw.contains('invalid_credentials') ||
        raw.contains('invalid grant')) {
      return 'Email atau password salah. Silakan coba lagi.';
    }
    if (raw.contains('email not confirmed') ||
        raw.contains('email_not_confirmed')) {
      return 'Email belum dikonfirmasi. Cek kotak masuk email Anda dan klik link konfirmasi.';
    }
    if (raw.contains('user already registered') ||
        raw.contains('already registered') ||
        raw.contains('already been registered')) {
      return 'Email ini sudah terdaftar. Silakan login atau gunakan email lain.';
    }
    if (raw.contains('password') && raw.contains('6')) {
      return 'Password minimal 6 karakter.';
    }
    if (raw.contains('rate limit') || raw.contains('too many requests')) {
      return 'Terlalu banyak percobaan. Tunggu beberapa saat lalu coba lagi.';
    }
    if (raw.contains('network') ||
        raw.contains('socketexception') ||
        raw.contains('connection')) {
      return 'Tidak dapat terhubung ke server. Periksa koneksi internet Anda.';
    }
    if (raw.contains('user not found')) {
      return 'Akun dengan email ini tidak ditemukan.';
    }
    // Generic fallback — show a cleaned-up version of the raw message
    final clean = error
        .toString()
        .replaceAll('AuthException:', '')
        .replaceAll('Exception:', '')
        .trim();
    return clean.isNotEmpty ? clean : 'Terjadi kesalahan. Silakan coba lagi.';
  }
}
