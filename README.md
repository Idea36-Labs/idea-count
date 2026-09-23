# Idea Count - Simple Counter

## Product Definition

- **Name**: Idea Count
- **Goal**: A simple, fast, and minimalist digital counter to increase or decrease a value with a single tap.
- **Problem it solves**: Enables quick counting without distractions, replacing improvised methods such as mental counting, tallying on paper, or apps cluttered with unnecessary features.
- **Audience**: Users who need to count things quickly: workout repetitions, items, scores, tasks, or any simple day-to-day counting.
- **Platforms**: Android.
- **V1 Features (essentials only)**:
    - Display a centered number on screen.
    - Initial value: **0**.
    - **+** button to increment.
    - **-** button to decrement.
    - Instant value update.
    - Number pulse / scale effect (Scale Animation).
    - Haptic feedback (vibration on tap).
    - Save last value.
    - Reset button.
    - Jump animation on reset (Reset Jump).
    - Confirmation dialog on reset.
    - Minimalist interface.
- **Potential future features (out of scope for V1)**:
    - Sounds.
    - Dark mode.
    - Count history.
    - Multiple counters.
    - Custom themes.
    - Data backup.
    - Advanced animations and visual effects.
    - Login and cross-device sync.
    - Ads.

## Design

**Description**: Simple counter with a large dark number in the center of the screen. Below the number are two buttons, "-" and "+", to increase or decrease the number, which initially starts at 0. The buttons are large and round, with decrement in gray and increment in yellow.

<img src="docs/images/idea_count_preview_1.jpg" alt="Idea Count Preview" width="200"/> <img src="docs/images/idea_count_preview_2.jpg" alt="Idea Count Preview" width="200"/> <img src="docs/images/idea_count_preview_3.jpg" alt="Idea Count Preview" width="200"/>


Idea Count follows the Idea36 Labs visual identity:

- Minimalist interface.
- White background.
- Inter typography.
- Large centered number.
- Idea36 Yellow (#FFC107) as the primary action color.
- High contrast and few elements.

#### Principles:

- Simplicity;
- Quick usage;
- Focus on the counter;
- One-handed experience.

## Architecture

### Folder structure

```
lib/
├── main.dart
├── pages/
│   └── counter_page.dart
├── widgets/
│   └── counter_button.dart
├── theme/
│   └── app_theme.dart
└── utils/
```

### Responsibilities

#### main.dart

Application entry point.

- Initializes the application.
- Configures the theme.
- Defines the home screen.

#### pages/

Contains the full screens of the application.

#### widgets/

Reusable components independent of application logic.

#### theme/

Centralizes:

- Colors;
- Typography;
- Styles;
- Material Theme.

Avoids colors and styles scattered throughout the code.

#### utils/

Helper functions that do not belong to any specific screen or widget.

### State management

V1 uses only `StatefulWidget` and `setState()`.

If the application grows, migrating to a solution like Provider, Riverpod, or Bloc will only be considered when needed.

### Privacy Policy

Privacy policy link for the **Idea Count** app: 

🔗 [idea36labs.com/ideacount/privacy](http://www.idea36labs.com/ideacount/privacy.html)