import 'package:audioplayers/audioplayers.dart';

import 'i_sound_service.dart';

/// Manages pre-buffered audio playback for UI interaction sounds.
///
/// Uses [AudioPool] with [PlayerMode.lowLatency] (Android SoundPool) to
/// minimize initialization and playback latency on rapid repeated triggers.
/// Each sound has its own pool with up to 4 concurrent players.
///
/// Must call [dispose] when the owning widget is unmounted.
class SoundService implements ISoundService {
  static const double _volume = 0.55;

  /// Duration of each WAV asset — used to auto-return players to the pool
  /// since [PlayerMode.lowLatency] does not fire [onPlayerComplete].
  static const Duration _soundDuration = Duration(milliseconds: 75);

  /// Pre-buffered pool for the increment sound.
  late final Future<AudioPool> _incrementPool;

  /// Pre-buffered pool for the decrement sound.
  late final Future<AudioPool> _decrementPool;

  SoundService() {
    _incrementPool = AudioPool.create(
      source: AssetSource('sounds/increment.wav'),
      minPlayers: 1,
      maxPlayers: 4,
      // lowLatency maps to Android SoundPool: audio is loaded into RAM,
      // making resume() near-instantaneous after the first setSource call.
      playerMode: PlayerMode.lowLatency,
    );
    _decrementPool = AudioPool.create(
      source: AssetSource('sounds/decrement.wav'),
      minPlayers: 1,
      maxPlayers: 4,
      playerMode: PlayerMode.lowLatency,
    );
  }

  /// Plays the increment (higher-pitch) sound effect.
  ///
  /// Fails silently on audio errors to avoid disrupting the UI.
  @override
  Future<void> playIncrement() async {
    try {
      final pool = await _incrementPool;
      final stop = await pool.start(volume: _volume);
      // lowLatency mode does not fire onPlayerComplete, so we manually
      // schedule the stop callback to return the player to the pool.
      Future.delayed(_soundDuration, stop);
    } catch (_) {}
  }

  /// Plays the decrement (lower-pitch) sound effect.
  ///
  /// Fails silently on audio errors to avoid disrupting the UI.
  @override
  Future<void> playDecrement() async {
    try {
      final pool = await _decrementPool;
      final stop = await pool.start(volume: _volume);
      Future.delayed(_soundDuration, stop);
    } catch (_) {}
  }

  /// Releases all audio resources held by this service.
  ///
  /// Must be called inside the owner's [dispose] lifecycle method.
  @override
  Future<void> dispose() async {
    try {
      await (await _incrementPool).dispose();
      await (await _decrementPool).dispose();
    } catch (_) {}
  }
}
