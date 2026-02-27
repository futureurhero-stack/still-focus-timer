import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'app.dart';
import 'core/locale/locale_provider.dart';
import 'data/local/database_service.dart';

/// 앱의 진입점
void main() async {
  // Flutter 바인딩 초기화
  WidgetsFlutterBinding.ensureInitialized();

  // 한국어 로케일 초기화
  await initializeDateFormatting('ko_KR', null);

  // 데이터베이스 초기화
  await DatabaseService().init();

  // 초기 로케일: 저장된 설정 → 없으면 기기 언어(en/ko) → 그 외 영어
  final initialLocale = await _resolveInitialLocale();

  // 시스템 UI 설정
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF1A1625),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  // 세로 모드 고정
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // 앱 실행 (초기 로케일로 Provider 초기화)
  runApp(
    ProviderScope(
      overrides: [
        localeProvider.overrideWith(
          (ref) => LocaleNotifier(initial: initialLocale),
        ),
      ],
      child: const FocusFlowApp(),
    ),
  );
}

/// 저장된 언어 설정 또는 기기 언어로 초기 Locale 결정
Future<Locale> _resolveInitialLocale() async {
  const supported = ['en', 'ko'];

  // 1) 사용자가 Settings에서 저장한 값이 있으면 우선 사용
  final saved = await DatabaseService().getSetting<String>('locale');
  if (saved != null && supported.contains(saved)) {
    return Locale(saved);
  }

  // 2) 없으면 기기 언어에 맞춤 (지원하는 경우만)
  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final code = deviceLocale.languageCode.toLowerCase();
  if (supported.contains(code)) {
    return Locale(code);
  }
  // 3) 지원하지 않으면 영어
  return const Locale('en');
}
