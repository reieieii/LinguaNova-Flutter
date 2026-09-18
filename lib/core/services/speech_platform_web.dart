import 'dart:html' as html;
import 'package:flutter/foundation.dart';

void speakWebDirect(String text, String langCode) {
  if (text.trim().isEmpty) return;

  try {
    final synthesis = html.window.speechSynthesis;
    if (synthesis == null) return;

    synthesis.cancel();
    synthesis.resume();
    final utterance = html.SpeechSynthesisUtterance(text)
      ..lang = langCode
      ..rate = 0.85
      ..volume = 1.0;

    final fallbackLang = langCode.split('-').first.toLowerCase();
    for (final voice in synthesis.getVoices()) {
      final voiceLang = voice.lang?.toLowerCase() ?? '';
      if (voiceLang == langCode.toLowerCase() ||
          voiceLang.startsWith('$fallbackLang-')) {
        utterance.voice = voice;
        break;
      }
    }

    synthesis.speak(utterance);
  } catch (error) {
    debugPrint('Web TTS Error: $error');
  }
}
