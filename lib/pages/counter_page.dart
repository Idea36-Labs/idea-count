import 'package:flutter/material.dart';
import '../widgets/counter_button.dart';
import '../widgets/counter_display.dart';
import '../widgets/reset_confirmation_dialog.dart';
import '../services/i_counter_storage.dart';
import '../services/i_sound_service.dart';

/// Main screen of Idea Count.
///
/// Responsible for:
/// - displaying the current counter value;
/// - controlling the counter state;
/// - organizing the visual elements of the screen.
///
/// Since the application is simple, state management will be handled
/// using StatefulWidget + setState().
class CounterPage extends StatefulWidget {
  /// The shared [ISoundService] instance injected from [main].
  final ISoundService soundService;

  /// The storage backend injected from [main].
  ///
  /// Accepts any [ICounterStorage] implementation, enabling in-memory
  /// fakes to be used in tests without touching widget code.
  final ICounterStorage storageService;

  /// Default constructor for the screen.
  const CounterPage({super.key, required this.soundService, required this.storageService});

  @override
  State<CounterPage> createState() => _CounterPageState();
}

/// Internal state of CounterPage.
///
/// Holds the current counter value and updates the interface
/// whenever this value changes.
///
/// The counter is bounded to the interval [_kMinCount, _kMaxCount].
/// Mutations that would exceed either bound are silently ignored —
/// no state update, persistence, or audio is triggered in those cases.
class _CounterPageState extends State<CounterPage> {
  static const int _kMinCount = 0;
  static const int _kMaxCount = 9999;

  int _count = 0;

  @override
  void initState() {
    super.initState();
    _loadCounter();
  }

  @override
  void dispose() {
    widget.soundService.dispose();
    super.dispose();
  }

  Future<void> _loadCounter() async {
    final value = await widget.storageService.loadCounter();
    if (!mounted) return;
    setState(() {
      // Clamp guards against corrupted or out-of-range persisted data.
      _count = value.clamp(_kMinCount, _kMaxCount);
    });
  }

  Future<void> _saveCounter(int value) async {
    await widget.storageService.saveCounter(value);
  }

  void _increment() {
    if (_count >= _kMaxCount) return;
    final newCount = _count + 1;
    setState(() => _count = newCount);
    _saveCounter(newCount);
    widget.soundService.playIncrement();
  }

  void _decrement() {
    if (_count > 0) {
      final newCount = _count - 1;
      setState(() => _count = newCount);
      _saveCounter(newCount);
      widget.soundService.playDecrement();
    }
  }

  void _showResetConfirmationDialog() {
    showDialog<void>(
      context: context,
      builder: (_) => ResetConfirmationDialog(onConfirm: _reset),
    );
  }

  void _reset() {
    setState(() => _count = 0);
    _saveCounter(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 24),
              child: Text(
                'IDEA COUNT',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                  color: Color(0xFF1A1A1A),
                ),
              ),
            ),
            Expanded(
              child: Center(child: CounterDisplay(count: _count)),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40, left: 24, right: 24),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CounterButton(icon: Icons.remove, onPressed: _decrement),
                      const SizedBox(width: 32),
                      CounterButton(
                        icon: Icons.add,
                        onPressed: _increment,
                        isPrimary: true,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: _showResetConfirmationDialog,
                    style: OutlinedButton.styleFrom(
                      fixedSize: const Size(120, 30),
                      side: const BorderSide(
                        color: Color(0xFFE0E0E0),
                        width: 1,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      'RESET COUNT',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: Color(0xFF5B4300),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
