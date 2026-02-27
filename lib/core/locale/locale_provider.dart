import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/local/database_service.dart';

/// 로케일 설정 저장 키
const String _localeSettingKey = 'locale';

/// 앱의 현재 언어 상태를 관리하는 Notifier
/// 초기값: 저장된 설정이 있으면 사용, 없으면 기기 언어(en/ko)에 맞춤.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier({Locale? initial}) : super(initial ?? const Locale('en'));

  /// Locale 변경 후 설정에 저장 (Settings에서 변경 시 유지)
  void setLocale(Locale locale) {
    state = locale;
    DatabaseService().setSetting<String>(_localeSettingKey, locale.languageCode);
  }

  /// 영어로 변경
  void setEnglish() => setLocale(const Locale('en'));

  /// 한국어로 변경
  void setKorean() => setLocale(const Locale('ko'));
}

/// 전역에서 사용하는 Locale Provider
/// main()에서 초기 로케일을 넘기려면 ProviderScope overrides 사용.
final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());


