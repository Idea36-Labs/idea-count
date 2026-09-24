import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:idea_count/pages/counter_page.dart';
import 'package:idea_count/services/i_counter_storage.dart';
import 'package:idea_count/services/i_sound_service.dart';
import 'package:idea_count/theme/app_theme.dart';

// ---------------------------------------------------------------------------
// Fakes
// ---------------------------------------------------------------------------

/// In-memory [ICounterStorage] — no platform plugin, no I/O.
final class _FakeStorage implements ICounterStorage {
  int _value;

  _FakeStorage([int initialValue = 0]) : _value = initialValue;

  @override
  Future<int> loadCounter() async => _value;

  @override
  Future<bool> saveCounter(int value) async {
    _value = value;
    return true;
  }
}

/// No-op [ISoundService] — prevents native AudioPool initialisation in tests.
final class _FakeSoundService implements ISoundService {
  @override
  Future<void> playIncrement() async {}

  @override
  Future<void> playDecrement() async {}

  @override
  Future<void> dispose() async {}
}

// ---------------------------------------------------------------------------
// Helper
// ---------------------------------------------------------------------------

/// Builds a [CounterPage] wrapped in [MaterialApp] with injectable fakes.
Widget _buildCounter({ICounterStorage? storage, ISoundService? sound}) {
  return MaterialApp(
    theme: AppTheme.lightTheme,
    home: CounterPage(
      storageService: storage ?? _FakeStorage(),
      soundService: sound ?? _FakeSoundService(),
    ),
  );
}

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  group('CounterPage — initial state', () {
    testWidgets('displays 0 when no value is persisted', (tester) async {
      await tester.pumpWidget(_buildCounter());
      await tester.pump(); // settle async _loadCounter
      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('loads persisted value from storage on init', (tester) async {
      await tester.pumpWidget(_buildCounter(storage: _FakeStorage(42)));
      await tester.pump();
      expect(find.text('42'), findsOneWidget);
    });

    testWidgets('clamps stored value above max to 9999', (tester) async {
      await tester.pumpWidget(_buildCounter(storage: _FakeStorage(99999)));
      await tester.pump();
      expect(find.text('9999'), findsOneWidget);
    });

    testWidgets('clamps stored value below min to 0', (tester) async {
      await tester.pumpWidget(_buildCounter(storage: _FakeStorage(-5)));
      await tester.pump();
      expect(find.text('0'), findsOneWidget);
    });
  });

  group('CounterPage — increment', () {
    testWidgets('increments counter on + tap', (tester) async {
      await tester.pumpWidget(_buildCounter());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('1'), findsOneWidget);
    });

    testWidgets('does not increment above 9999', (tester) async {
      await tester.pumpWidget(_buildCounter(storage: _FakeStorage(9999)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(find.text('9999'), findsOneWidget);
    });

    testWidgets('persists incremented value to storage', (tester) async {
      final storage = _FakeStorage(0);
      await tester.pumpWidget(_buildCounter(storage: storage));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.add));
      await tester.pump();

      expect(storage._value, 1);
    });
  });

  group('CounterPage — decrement', () {
    testWidgets('decrements counter on - tap', (tester) async {
      await tester.pumpWidget(_buildCounter(storage: _FakeStorage(5)));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('4'), findsOneWidget);
    });

    testWidgets('does not decrement below 0', (tester) async {
      await tester.pumpWidget(_buildCounter());
      await tester.pump();

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(find.text('0'), findsOneWidget);
    });

    testWidgets('persists decremented value to storage', (tester) async {
      final storage = _FakeStorage(3);
      await tester.pumpWidget(_buildCounter(storage: storage));
      await tester.pump();

      await tester.tap(find.byIcon(Icons.remove));
      await tester.pump();

      expect(storage._value, 2);
    });
  });
}
