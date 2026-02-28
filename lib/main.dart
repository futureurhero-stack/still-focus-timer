import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

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

  // Firebase 초기화 (분석 등) - 구성 파일이 없으면 조용히 실패
  await _initFirebase();

  // 초기 로케일: 저장된 설정이 있으면 사용, 없으면(초기 설치) 기기 언어에 맞춤
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

/// 초기 설치 시 기기 언어를 따르고, 이후에는 Settings 저장값을 사용
Future<Locale> _resolveInitialLocale() async {
  const supported = ['en', 'ko'];

  // 1) 사용자가 Settings에서 저장한 값이 있으면 우선 사용
  final saved = await DatabaseService().getSetting<String>('locale');
  if (saved != null && supported.contains(saved)) {
    return Locale(saved);
  }

  // 2) 초기 설치(저장값 없음): 휴대폰 언어설정에 맞춤
  final deviceLocale = WidgetsBinding.instance.platformDispatcher.locale;
  final code = deviceLocale.languageCode.toLowerCase();
  if (supported.contains(code)) {
    return Locale(code);
  }
  // 3) 앱이 지원하지 않는 언어면 기기 로케일 그대로 전달 → 앱에서 지원 목록으로 해석
  return deviceLocale;
}

/// Firebase Core 및 Analytics 초기화
Future<void> _initFirebase() async {
  try {
    await Firebase.initializeApp();
    // 실행 로그에서 초기화 확인용 (정상 시 이 메시지가 보임)
    debugPrint('FirebaseApp initialized');
    // 기본 앱 열림 이벤트
    await FirebaseAnalytics.instance.logAppOpen();
  } catch (_) {
    // Firebase 구성 파일이 아직 없는 경우 등을 대비해 실패는 조용히 무시
  }
}
