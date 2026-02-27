import 'package:flutter/material.dart';

/// Still Focus 앱의 색상 시스템
/// 산뜻하고 깔끔한 미니멀 디자인 (샘플 스타일)
/// — 4가지 감정 색상 버전 (emotionTired, emotionStressed, emotionSleepy, emotionGood)
class AppColors {
  AppColors._();

  // ===== Primary Colors =====
  static const Color primary = Color(0xFFF5F0EB);
  static const Color primaryLight = Color(0xFFFAF7F2);
  static const Color primaryDark = Color(0xFFEAE0D5);

  // ===== Accent Colors =====
  // 산뜻한 오렌지/코랄 - 포커스 포인트
  static const Color accent = Color(0xFFE87D54);
  static const Color accentLight = Color(0xFFF5A082);
  static const Color accentDark = Color(0xFFD96A42);

  // ===== Background Colors =====
  static const Color background = Color(0xFFF8F9FA);
  static const Color backgroundLight = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF0F2F5);

  // ===== Text Colors =====
  static const Color textPrimary = Color(0xFF2C2C2C);
  static const Color textSecondary = Color(0xFF6B6B6B);
  static const Color textMuted = Color(0xFF9B9B9B);

  // ===== Emotion Colors =====
  static const Color emotionTired = Color(0xFF3C6FF2);     // refined blue
  static const Color emotionStressed = Color(0xFFE44A6A);  // deep rose (Overwhelmed)
  static const Color emotionSleepy = Color(0xFF6E5CF6);    // refined violet
  static const Color emotionGood = Color(0xFF12A594);      // premium teal

  // ===== Status Colors =====
  static const Color success = Color(0xFF8B9A7A);
  static const Color warning = Color(0xFFD4A574);
  static const Color error = Color(0xFFC89B7B);
  static const Color info = Color(0xFF9A8B7A);

  // ===== Timer Colors =====
  static const Color timerActive = Color(0xFFB08968);
  static const Color timerPaused = Color(0xFFD4C9BC);
  static const Color timerCompleted = Color(0xFF8B9A7A);
  static const Color timerFailed = Color(0xFFC89B7B);

  // ===== Gradient Definitions =====
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [accent, accentDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFBF7), Color(0xFFF5F0EB)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceLight],
  );

  // ===== Liquid Glass Effect =====
  // Still Focus Timer - 프리미엄 글래스모피즘
  static const Color glassBackground = Color(0x35EAE0D5);
  static const Color glassBackgroundLight = Color(0x55F5F0EB);
  static const Color glassBackgroundDark = Color(0x15D4C9BC);
  static const Color glassBorder = Color(0x45B08968);
  static const Color glassBorderLight = Color(0x35FFFFFF);
  static const Color glassHighlight = Color(0x40FFFFFF);
  static const Color glassShadow = Color(0x15000000);
  static const Color glassInnerGlow = Color(0x08FFFFFF);
  static const Color glassProgressTrack = Color(0x18EAE0D5);
}




