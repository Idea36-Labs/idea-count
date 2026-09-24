/// Contract for counter value persistence.
///
/// Abstracts the storage backend so that [CounterPage] depends only on
/// this interface, enabling in-memory fakes or alternative backends
/// to be injected without touching UI code.
abstract interface class ICounterStorage {
  /// Reads the last saved counter value.
  ///
  /// Returns `0` if no value has been saved yet or if an error occurs.
  Future<int> loadCounter();

  /// Persists [value] to storage.
  ///
  /// Returns `true` on success, `false` on error.
  Future<bool> saveCounter(int value);
}
