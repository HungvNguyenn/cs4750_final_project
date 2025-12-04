import 'package:audioplayers/audioplayers.dart';

class Sfx {
  static final AudioPlayer _player = AudioPlayer();

  static Future<void> _play(String assetPath) async {
    try {
      await _player.stop();
      await _player.play(AssetSource(assetPath));
    } catch (e) {
      print("Audio error: $e");
    }
  }

  static Future<void> click()   => _play('sounds/click.wav');
  static Future<void> correct() => _play('sounds/correct.wav');
  static Future<void> reset()   => _play('sounds/reset.mp3');
  static Future<void> wrong() => _play('sounds/wrong.mp3');
}
