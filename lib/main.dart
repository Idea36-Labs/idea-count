import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'pages/counter_page.dart';
import 'services/counter_storage_service.dart';
import 'services/i_counter_storage.dart';
import 'services/i_sound_service.dart';
import 'services/sound_service.dart';
import 'theme/app_theme.dart';

/// Entry point of the application.
///
/// Every Flutter application starts its execution from this function.
/// It is responsible for initializing the main application widget.
void main() async {
  // Ensures initialization of Flutter bindings with the native platform.
  WidgetsFlutterBinding.ensureInitialized();

  // SoundService is created here — before runApp — so AudioPool.create()
  // has maximum warm-up time before the user can interact with the UI.
  final soundService = SoundService();
  final storageService = CounterStorageService();

  // Locks the application orientation exclusively to Portrait mode.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(IdeaCountApp(soundService: soundService, storageService: storageService));
}

/// Root widget of the application.
///
/// Its sole responsibility is to configure the application:
/// - name;
/// - global theme;
/// - initial screen.
///
/// No business rules should reside here.
class IdeaCountApp extends StatelessWidget {
  /// The shared [ISoundService] instance, created in [main] for early warm-up.
  final ISoundService soundService;

  /// The storage backend, created in [main] and injected for testability.
  final ICounterStorage storageService;

  /// Default constructor.
  const IdeaCountApp({super.key, required this.soundService, required this.storageService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Removes the "DEBUG" banner displayed during development.
      debugShowCheckedModeBanner: false,

      // Application name.
      title: 'Idea Count',

      // Global application theme.
      //
      // All visual configurations (colors, typography, and styles)
      // will be centralized in app_theme.dart.
      theme: AppTheme.lightTheme,

      // First screen displayed when the application starts.
      home: CounterPage(soundService: soundService, storageService: storageService),
    );
  }
}