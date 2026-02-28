import 'package:firebase_analytics/firebase_analytics.dart';

import '../../data/models/emotion_type.dart';

/// Still Focus Timer — 수익화/Retention 분석용 Firebase Analytics 이벤트
///
/// 【정리·유지】
/// 1. screen_view — 홈/타이머/통계/회고/설정 화면 진입 (화면별 체류·이탈)
/// 2. mood_selected — 감정 카드 선택 시 (mood: 4가지 감정 구분, duration_minutes)
/// 3. quick_start — Quick Start(10분) 버튼 클릭 시 (mood: good)
/// 4. start_my_routine — Start my routine(기본 시간) 버튼 클릭 시 (mood: good)
///    ※ mood = Overwhelmed | Distracted | Low Energy | In the Zone (버튼 라벨과 동일)
///
/// 【추가권장】
/// 5. session_start — 타이머 세션 시작 (Retention: 세션 시작 수)
/// 6. session_complete — 목표 시간 달성 후 회고 이동 (수익화·완주율)
/// 7. session_abandon — 세션 포기 후 회고 이동 (이탈 원인: give_up_reason)
///
/// 【Google Play 수익화 (V1.0)】
/// 8. paywall_view — Paywall 노출 (전환율 측정)
/// 9. purchase_click — 구매 버튼 탭 (remove_ads 등)
/// 10. purchase_success — 구매 완료 (Google Play Billing)
/// 11. ads_removed — 광고 제거 확정 (구매 후 등)
class AppAnalytics {
  AppAnalytics._();

  static FirebaseAnalytics get _instance => FirebaseAnalytics.instance;

  // ---------- 이벤트 이름 (Firebase 권장 snake_case) ----------
  static const String eventScreenView = 'screen_view';
  static const String eventMoodSelected = 'mood_selected';
  static const String eventQuickStart = 'quick_start';
  static const String eventStartMyRoutine = 'start_my_routine';
  static const String eventSessionStart = 'session_start';
  static const String eventSessionComplete = 'session_complete';
  static const String eventSessionAbandon = 'session_abandon';
  static const String eventPaywallView = 'paywall_view';
  static const String eventPurchaseClick = 'purchase_click';
  static const String eventPurchaseSuccess = 'purchase_success';
  static const String eventAdsRemoved = 'ads_removed';

  // ---------- 파라미터 키 ----------
  static const String paramScreenName = 'screen_name';
  static const String paramScreenClass = 'screen_class';
  static const String paramMood = 'mood';
  static const String paramDurationMinutes = 'duration_minutes';
  static const String paramIsCompleted = 'is_completed';
  static const String paramGiveUpReason = 'give_up_reason';
  static const String paramProductId = 'product_id';
  static const String paramSource = 'source';

  /// 인앱 상품 ID (Google Play Billing 비구독)
  static const String productRemoveAds = 'remove_ads';

  // ---------- mood 라벨 (버튼과 동일: Overwhelmed, Distracted, Low Energy, In the Zone) ----------
  static const Map<EmotionType, String> _moodLabels = {
    EmotionType.stressed: 'Overwhelmed',
    EmotionType.tired: 'Distracted',
    EmotionType.sleepy: 'Low Energy',
    EmotionType.good: 'In the Zone',
  };

  /// 4가지 감정 모드 → Firebase에 보낼 mood 문자열
  static String moodLabel(EmotionType emotion) =>
      _moodLabels[emotion] ?? 'In the Zone';

  /// enum 이름(stressed/tired/sleepy/good) → mood 문자열 (문자열만 있을 때 사용)
  static String moodLabelFromEnumName(String enumName) {
    switch (enumName) {
      case 'stressed':
        return 'Overwhelmed';
      case 'tired':
        return 'Distracted';
      case 'sleepy':
        return 'Low Energy';
      case 'good':
        return 'In the Zone';
      default:
        return 'In the Zone';
    }
  }

  // ---------- 화면 이름 (screen_view용) ----------
  static const String screenHome = 'home';
  static const String screenTimer = 'timer';
  static const String screenReflection = 'reflection';
  static const String screenAnalytics = 'analytics';
  static const String screenSettings = 'settings';

  /// screen_view — 홈/타이머/통계 등 화면 진입 (수익화: 화면별 체류·이탈)
  static Future<void> logScreenView({
    required String screenName,
    String? screenClass,
  }) async {
    try {
      await _instance.logScreenView(
        screenName: screenName,
        screenClass: screenClass ?? screenName,
      );
    } catch (_) {
      // Firebase 미구성 시 조용히 무시
    }
  }

  /// mood_selected — 감정 카드 선택 (mood: Overwhelmed | Distracted | Low Energy | In the Zone)
  static Future<void> logMoodSelected({
    required EmotionType emotion,
    required int durationMinutes,
  }) async {
    try {
      await _instance.logEvent(
        name: eventMoodSelected,
        parameters: {
          paramMood: moodLabel(emotion),
          paramDurationMinutes: durationMinutes,
        },
      );
    } catch (_) {}
  }

  /// quick_start — Quick Start(10분) 버튼 클릭 (mood: In the Zone)
  static Future<void> logQuickStart({int durationMinutes = 10}) async {
    try {
      await _instance.logEvent(
        name: eventQuickStart,
        parameters: {
          paramMood: moodLabel(EmotionType.good),
          paramDurationMinutes: durationMinutes,
        },
      );
    } catch (_) {}
  }

  /// start_my_routine — Start my routine(기본 시간) 버튼 클릭 (mood: In the Zone)
  static Future<void> logStartMyRoutine({required int durationMinutes}) async {
    try {
      await _instance.logEvent(
        name: eventStartMyRoutine,
        parameters: {
          paramMood: moodLabel(EmotionType.good),
          paramDurationMinutes: durationMinutes,
        },
      );
    } catch (_) {}
  }

  /// session_start — 타이머 세션 시작 (mood: Overwhelmed | Distracted | Low Energy | In the Zone)
  static Future<void> logSessionStart({
    required EmotionType emotion,
    required int durationMinutes,
  }) async {
    try {
      await _instance.logEvent(
        name: eventSessionStart,
        parameters: {
          paramMood: moodLabel(emotion),
          paramDurationMinutes: durationMinutes,
        },
      );
    } catch (_) {}
  }

  /// session_complete — 목표 시간 달성 후 회고로 이동 (수익화·Retention 핵심)
  /// [mood] 4가지 감정 모드 중 어떤 모드로 세션했는지
  static Future<void> logSessionComplete({
    required int durationMinutes,
    required String mood,
  }) async {
    try {
      await _instance.logEvent(
        name: eventSessionComplete,
        parameters: {
          paramMood: mood,
          paramDurationMinutes: durationMinutes,
        },
      );
    } catch (_) {}
  }

  /// session_abandon — 세션 포기 후 회고로 이동 (이탈 원인 분석)
  /// [mood] 4가지 감정 모드 중 어떤 모드였는지
  static Future<void> logSessionAbandon({
    required String giveUpReason,
    required int elapsedMinutes,
    required String mood,
  }) async {
    try {
      await _instance.logEvent(
        name: eventSessionAbandon,
        parameters: {
          paramMood: mood,
          paramGiveUpReason: giveUpReason,
          paramDurationMinutes: elapsedMinutes,
        },
      );
    } catch (_) {}
  }

  // ---------- Google Play 수익화 (V1.0: Free + Ads, remove_ads IAP) ----------

  /// paywall_view — Paywall 화면 노출 (전환율 측정)
  static Future<void> logPaywallView({String? source}) async {
    try {
      await _instance.logEvent(
        name: eventPaywallView,
        parameters: source != null ? {paramSource: source} : {},
      );
    } catch (_) {}
  }

  /// purchase_click — 구매 버튼 탭 (remove_ads 등, Google Play Billing)
  static Future<void> logPurchaseClick({required String productId}) async {
    try {
      await _instance.logEvent(
        name: eventPurchaseClick,
        parameters: {paramProductId: productId},
      );
    } catch (_) {}
  }

  /// purchase_success — 구매 완료 (Google Play Billing)
  static Future<void> logPurchaseSuccess({required String productId}) async {
    try {
      await _instance.logEvent(
        name: eventPurchaseSuccess,
        parameters: {paramProductId: productId},
      );
    } catch (_) {}
  }

  /// ads_removed — 광고 제거 확정 (구매 완료 후 등)
  static Future<void> logAdsRemoved({String? source}) async {
    try {
      await _instance.logEvent(
        name: eventAdsRemoved,
        parameters: source != null ? {paramSource: source} : {},
      );
    } catch (_) {}
  }
}
