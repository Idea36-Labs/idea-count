/// Contract for UI audio feedback.
///
/// Abstracts the audio backend so [CounterPage] depends only on this
/// interface, allowing no-op fakes to be injected during tests without
/// initialising any native plugin.
abstract interface class ISoundService {
  /// Plays the increment sound effect.
  Future<void> playIncrement();

  /// Plays the decrement sound effect.
  Future<void> playDecrement();

  /// Releases all audio resources.
  ///
  /// Must be called inside the owner's [dispose] lifecycle method.
  Future<void> dispose();
}
