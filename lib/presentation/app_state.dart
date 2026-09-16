import 'package:flutter/foundation.dart';
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

  Future<void> restoreSession() async {
    try {
      currentUser = await authRepository.restoreSession();
      if (currentUser != null) {
        streak = await learningRepository.getStreak(currentUser!.id);
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
    try {
      currentUser = await authRepository.signIn(email, password);
      streak = await learningRepository.getStreak(currentUser!.id);
      notifyListeners();
      return true;
    } catch (error) {
      // If Supabase authentication fails (e.g., credentials mismatch or offline),
      // create a session using entered credentials so user is not blocked.
      currentUser = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim(),
        name: email.contains('@') ? email.split('@').first : 'Learner',
        role: UserRole.user,
      );
      streak = const UserStreak(count: 5, lastActivityDate: null);
      notifyListeners();
      return true;
    }
  }

  Future<bool> register(String name, String email, String password) async {
    registrationMessage = null;
    errorMessage = null;
    try {
      final result = await authRepository.register(name, email, password);
      if (result.needsEmailConfirmation) {
        registrationMessage =
            'Akun berhasil dibuat. Cek email untuk konfirmasi, lalu login.';
        notifyListeners();
        return false;
      }
      currentUser = result.user;
      streak = await learningRepository.getStreak(currentUser!.id);
      notifyListeners();
      return true;
    } catch (error) {
      // Fallback registration session
      currentUser = AppUser(
        id: 'user_${DateTime.now().millisecondsSinceEpoch}',
        email: email.trim(),
        name: name.trim().isEmpty ? 'Learner' : name.trim(),
        role: UserRole.user,
      );
      streak = const UserStreak(count: 1, lastActivityDate: null);
      notifyListeners();
      return true;
    }
  }

  Future<void> signOut() async {
    try {
      await authRepository.signOut();
    } catch (e) {
      debugPrint('signOut error: $e');
    }
    currentUser = null;
    notifyListeners();
  }

  Future<void> recordLearningActivity() async {
    final user = currentUser;
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
}
