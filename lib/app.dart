import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/locale/locale_provider.dart';
import 'screens/home_screen.dart';
import 'features/timer/screens/timer_screen.dart';
import 'features/reflection/screens/reflection_screen.dart';
import 'features/analytics/screens/analytics_screen.dart';
import 'features/settings/screens/settings_screen.dart';
import 'data/models/emotion_type.dart';

/// 앱의 라우터 설정
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: '/',
    routes: [
      // 홈 화면
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      // 타이머 화면
      GoRoute(
        path: '/timer',
        name: 'timer',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return TimerScreen(
            emotion: extra?['emotion'] as EmotionType? ?? EmotionType.good,
            duration: extra?['duration'] as int? ?? 10,
            taskDescription: extra?['task'] as String?,
          );
        },
      ),
      // 회고 화면
      GoRoute(
        path: '/reflection',
        name: 'reflection',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ReflectionScreen(
            sessionId: extra?['sessionId'] as String? ?? '',
            actualDuration: extra?['actualDuration'] as int? ?? 0,
            isCompleted: extra?['isCompleted'] as bool? ?? true,
          );
        },
      ),
      // 통계 화면
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      // 설정 화면
      GoRoute(
        path: '/settings',
        name: 'settings',
        builder: (context, state) => const SettingsScreen(),
      ),
    ],
  );
});

/// FocusFlow 앱의 루트 위젯
class FocusFlowApp extends ConsumerWidget {
  const FocusFlowApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    final locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: AppStrings.appName(context),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      // 현재 선택된 언어 (설치 시 기기 언어 자동, Settings에서 변경 가능)
      locale: locale,
      // 지원하는 언어 목록 (미지원 기기 언어일 때 첫 항목 사용 → 영어 기본 아님)
      supportedLocales: const [
        Locale('ko'),
        Locale('en'),
      ],
      // Flutter 기본 로컬라이제이션 델리게이트 등록
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 기기/선택 언어가 지원 목록에 없을 때만 fallback (영어 기본 사용 안 함, 지원 목록 첫 항목 사용)
      localeResolutionCallback: (requestedLocale, supportedLocales) {
        if (requestedLocale == null || supportedLocales.isEmpty) {
          return supportedLocales.isNotEmpty ? supportedLocales.first : const Locale('en');
        }
        for (final locale in supportedLocales) {
          if (locale.languageCode == requestedLocale.languageCode) {
            return locale;
          }
        }
        return supportedLocales.first;
      },
      routerConfig: router,
    );
  }
}




