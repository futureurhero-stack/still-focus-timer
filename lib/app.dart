import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';

import 'core/theme/app_theme.dart';
import 'core/constants/app_strings.dart';
import 'core/locale/locale_provider.dart';
import 'features/home/screens/home_screen.dart';
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
      // 현재 선택된 언어 (기본: 영어)
      locale: locale,
      // 지원하는 언어 목록
      supportedLocales: const [
        Locale('en'),
        Locale('ko'),
      ],
      // Flutter 기본 로컬라이제이션 델리게이트 등록
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // 기기 언어가 지원되지 않을 경우 영어로 fallback
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        if (deviceLocale == null) {
          return const Locale('en');
        }
        for (final locale in supportedLocales) {
          if (locale.languageCode == deviceLocale.languageCode) {
            return locale;
          }
        }
        return const Locale('en');
      },
      routerConfig: router,
    );
  }
}




