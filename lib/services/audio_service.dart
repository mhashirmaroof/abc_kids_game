import 'package:flutter_tts/flutter_tts.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioService {
  static final FlutterTts _tts = FlutterTts();
  static final AudioPlayer _sfx = AudioPlayer();

  static Future<void> init() async {
    await _tts.setLanguage('en-US');
    await _tts.setSpeechRate(0.45);  // Slower = clearer for kids
    await _tts.setPitch(1.1);
    await _tts.setVolume(1.0);
  }

  static Future<void> speak(String text) async {
    await _tts.stop();  
    await _tts.speak(text);
  }

  static Future<void> playSuccess() async =>
      _sfx.play(AssetSource('sounds/success.wav'));

  static Future<void> playError() async =>
      _sfx.play(AssetSource('sounds/error.wav'));

  static Future<void> playCheer() async =>
      _sfx.play(AssetSource('sounds/cheer.wav'));

  static Future<void> stop() async {
    await _tts.stop();
    await _sfx.stop();
  }
}
