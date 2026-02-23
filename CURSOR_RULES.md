# Still: Focus Timer — Cursor Rules

## Goal
Recreate the attached PNG UI as a sophisticated self-management timer app UI in Flutter.

# IMPORTANT
Always follow this file before generating Flutter UI code.

## Style
- Material 3
- Soft neumorphism + subtle gradients
- Radius: 28–32
- Shadows: very soft (opacity <= 0.10), blur 16–24
- Spacing: 16/20/24 grid
- Typography: clean (Pretendard/SUIT if available; otherwise system)

## Code rules
- No image-based UI (do not place the PNG as background)
- Build reusable widgets
- Keep widgets small and testable
- Avoid heavy BackdropFilter everywhere (performance)

## Folder structure
lib/
  theme/app_theme.dart
  screens/home_screen.dart
  screens/focus_screen.dart
  screens/analytics_screen.dart
  widgets/mood_card.dart
  widgets/gradient_button.dart
  widgets/circular_timer.dart
  widgets/story_card.dart
  widgets/bottom_nav.dart

## Naming
- app name string: "Still: Focus Timer"
- keep android applicationId unchanged

## Output requirement
- Always provide full updated file contents for any file you modify.