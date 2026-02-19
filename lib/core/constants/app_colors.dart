import 'package:flutter/material.dart';

/// FocusFlow 앱의 색상 시스템
/// 따뜻하고 집중을 유도하는 컬러 팔레트
class AppColors {
  AppColors._();

  // ===== Primary Colors =====
  // 딥 오렌지 계열 - 에너지와 집중력을 상징
  static const Color primary = Color(0xFFFF6B35);
  static const Color primaryLight = Color(0xFFFF8F5E);
  static const Color primaryDark = Color(0xFFE55A2B);

  // ===== Secondary Colors =====
  // 딥 퍼플 계열 - 차분함과 깊은 집중
  static const Color secondary = Color(0xFF4A3F6B);
  static const Color secondaryLight = Color(0xFF6B5B8A);
  static const Color secondaryDark = Color(0xFF352D4D);

  // ===== Background Colors =====
  static const Color background = Color(0xFF1A1625);
  static const Color backgroundLight = Color(0xFF252033);
  static const Color surface = Color(0xFF2D2640);
  static const Color surfaceLight = Color(0xFF3D3555);

  // ===== Text Colors =====
  static const Color textPrimary = Color(0xFFF5F5F5);
  static const Color textSecondary = Color(0xFFB8B5C3);
  static const Color textMuted = Color(0xFF8A8697);

  // ===== Emotion Colors =====
  // 감정 선택에 사용되는 색상들
  static const Color emotionTired = Color(0xFF6C7CE0);      // 😫 하기 싫음
  static const Color emotionStressed = Color(0xFFE06C8A);   // 😰 스트레스
  static const Color emotionSleepy = Color(0xFF7CE0D3);     // 😴 졸림
  static const Color emotionGood = Color(0xFF8AE06C);       // 😃 괜찮음

  // ===== Status Colors =====
  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFB74D);
  static const Color error = Color(0xFFEF5350);
  static const Color info = Color(0xFF42A5F5);

  // ===== Timer Colors =====
  static const Color timerActive = Color(0xFFFF6B35);
  static const Color timerPaused = Color(0xFFFFB74D);
  static const Color timerCompleted = Color(0xFF4CAF50);
  static const Color timerFailed = Color(0xFFEF5350);

  // ===== Gradient Definitions =====
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [primary, primaryDark],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [background, Color(0xFF0F0D14)],
  );

  static const LinearGradient cardGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [surface, surfaceLight],
  );
}




