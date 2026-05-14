import 'package:audioplayers/audioplayers.dart';
import '../core/utils/logger.dart';

/// Centralized audio. Sound effect files should be placed under
/// assets/audio/sfx/ and music under assets/audio/music/. The service
/// tolerates missing files (logs and continues) so the game can run
/// before the audio team has shipped final assets.
class AudioService {
  AudioService._();
  static final AudioService instance = AudioService._();

  static const _tag = 'Audio';

  final AudioPlayer _music = AudioPlayer(playerId: 'music');
  final AudioPlayer _sfx = AudioPlayer(playerId: 'sfx');

  double _musicVolume = 0.6;
  double _sfxVolume = 0.85;

  Future<void> init() async {
    await _music.setReleaseMode(ReleaseMode.loop);
    await _music.setVolume(_musicVolume);
    await _sfx.setVolume(_sfxVolume);
  }

  void setMusicVolume(double v) {
    _musicVolume = v;
    _music.setVolume(v);
  }

  void setSfxVolume(double v) {
    _sfxVolume = v;
    _sfx.setVolume(v);
  }

  Future<void> playMusic(String asset) async {
    try {
      await _music.play(AssetSource(asset));
    } catch (e) {
      Log.w(_tag, 'Music asset missing: $asset');
    }
  }

  Future<void> stopMusic() => _music.stop();

  Future<void> playSfx(String asset) async {
    try {
      final p = AudioPlayer();
      await p.setVolume(_sfxVolume);
      await p.play(AssetSource(asset));
      p.onPlayerComplete.listen((_) => p.dispose());
    } catch (e) {
      Log.w(_tag, 'SFX asset missing: $asset');
    }
  }
}
