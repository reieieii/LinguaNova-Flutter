import 'package:flutter/foundation.dart';
import 'package:flutter_tts/flutter_tts.dart';

class SpeechService {
  factory SpeechService() => _instance;
  SpeechService._internal() {
    _initTts();
  }
  static final SpeechService _instance = SpeechService._internal();

  final FlutterTts _flutterTts = FlutterTts();
  bool _isInitialized = false;

  static const Map<String, Map<String, dynamic>> _languageConfig = {
    'japanese': {'lang': 'ja-JP', 'rate': 0.45},
    'chinese': {'lang': 'zh-CN', 'rate': 0.45},
    'korean': {'lang': 'ko-KR', 'rate': 0.45},
    'english': {'lang': 'en-US', 'rate': 0.50},
    'spanish': {'lang': 'es-ES', 'rate': 0.45},
  };

  Future<void> _initTts() async {
    if (_isInitialized) return;
    try {
      await _flutterTts.setVolume(1.0);
      await _flutterTts.setPitch(1.0);
      _isInitialized = true;
    } catch (e) {
      debugPrint('SpeechService init error: $e');
    }
  }

  Future<bool> speak(String text, {String languageId = 'japanese', double? rate}) async {
    if (text.trim().isEmpty) return false;
    await _initTts();

    final config = _languageConfig[languageId.toLowerCase()] ??
        {'lang': 'ja-JP', 'rate': 0.45};
    final String langCode = config['lang'] as String;
    final double speechRate = rate ?? (config['rate'] as double);

    try {
      await _flutterTts.stop();
      await _flutterTts.setLanguage(langCode);
      await _flutterTts.setSpeechRate(speechRate);
      await _flutterTts.speak(text);
      return true;
    } catch (e) {
      debugPrint('SpeechService speak error: $e');
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _flutterTts.stop();
    } catch (e) {
      debugPrint('SpeechService stop error: $e');
    }
  }
}
