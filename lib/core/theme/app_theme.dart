import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../constants/app_colors.dart';

/// FocusFlow 앱의 테마 설정
class AppTheme {
  AppTheme._();

  /// 라이트 테마 (프리미엄 베이지)
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      
      // 색상 스키마
      colorScheme: const ColorScheme.light(
        primary: AppColors.accent,
        onPrimary: AppColors.textPrimary,
        secondary: AppColors.primary,
        onSecondary: AppColors.textPrimary,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
        error: AppColors.error,
        onError: Colors.white,
      ),

      // 스캐폴드 배경색
      scaffoldBackgroundColor: AppColors.background,

      // 앱바 테마
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        systemOverlayStyle: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.dark,
        ),
        titleTextStyle: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 40,
          fontWeight: FontWeight.w600,
          color: AppColors.textPrimary,
        ),
        iconTheme: IconThemeData(
          color: AppColors.textPrimary,
        ),
      ),

      // 텍스트 테마
      textTheme: const TextTheme(
        // 대형 제목 (타이머 숫자용 - Bold만)
        displayLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 112,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -2,
        ),
        displayMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 72,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          letterSpacing: -1,
        ),
        displaySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 56,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        // 헤드라인 (Regular~Medium)
        headlineLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 48,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        headlineMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 40,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        headlineSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 36,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        // 타이틀 (Regular~Medium)
        titleLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 32,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        titleMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        titleSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        // 본문
        bodyLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 32,
          fontWeight: FontWeight.w400,
          color: AppColors.textPrimary,
        ),
        bodyMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 28,
          fontWeight: FontWeight.w400,
          color: AppColors.textSecondary,
        ),
        bodySmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 24,
          fontWeight: FontWeight.w400,
          color: AppColors.textMuted,
        ),
        // 레이블
        labelLarge: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 28,
          fontWeight: FontWeight.w500,
          color: AppColors.textPrimary,
        ),
        labelMedium: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 24,
          fontWeight: FontWeight.w500,
          color: AppColors.textSecondary,
        ),
        labelSmall: TextStyle(
          fontFamily: 'Pretendard',
          fontSize: 20,
          fontWeight: FontWeight.w500,
          color: AppColors.textMuted,
        ),
      ),

      // 카드 테마
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(32),
        ),
      ),

      // 버튼 테마
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.textPrimary,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 28,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.textPrimary,
          side: const BorderSide(color: AppColors.surfaceLight),
          padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 32),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(32),
          ),
          textStyle: const TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 32,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // 입력 필드 테마
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceLight,
        hintStyle: const TextStyle(
          color: AppColors.textMuted,
          fontFamily: 'Pretendard',
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.primary, width: 4),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: const BorderSide(color: AppColors.error, width: 4),
        ),
      ),

      // 바텀 내비게이션 테마
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textMuted,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
      ),

      // 다이얼로그 테마
      dialogTheme: DialogThemeData(
        backgroundColor: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
      ),

      // 스낵바 테마
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceLight,
        contentTextStyle: const TextStyle(
          color: AppColors.textPrimary,
          fontFamily: 'Pretendard',
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        behavior: SnackBarBehavior.floating,
      ),

      // 아이콘 테마
      iconTheme: const IconThemeData(
        color: AppColors.textPrimary,
        size: 48,
      ),

      // 디바이더 테마
      dividerTheme: const DividerThemeData(
        color: AppColors.surfaceLight,
        thickness: 1,
      ),
    );
  }
}

