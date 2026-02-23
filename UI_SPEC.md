# Still: Focus Timer — UI Spec

## Goal
Recreate UI from images in /design_refs exactly in Flutter (Android-first, responsive).

## Screens
- Home (mood grid + quick start + bottom nav)
- Focus (large circular timer + task + Pause/Give Up)
- Analytics (story gradient card + weekly bars + insight list)

## Style
- Soft gradient background
- Rounded cards radius 28–32
- Very soft shadow (opacity <= 0.10, blur 16–24)
- Clean typography (Pretendard/SUIT if available)

## Rules
- Do NOT use the PNG as UI background.
- Build with Flutter widgets.
- Componentize: MoodCard, GradientButton, BottomNav, CircularTimer.
- Keep performance: avoid excessive BackdropFilter.