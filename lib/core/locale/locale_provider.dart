import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// 앱의 현재 언어 상태를 관리하는 Notifier
/// 기본값은 영어(en) 입니다.
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en'));

  /// 임의의 Locale 설정
  void setLocale(Locale locale) => state = locale;

  /// 영어로 변경
  void setEnglish() => setLocale(const Locale('en'));

  /// 한국어로 변경
  void setKorean() => setLocale(const Locale('ko'));
}

/// 전역에서 사용하는 Locale Provider
final localeProvider =
    StateNotifierProvider<LocaleNotifier, Locale>((ref) => LocaleNotifier());


