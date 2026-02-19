import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// 알림 서비스
class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _isInitialized = false;

  /// 초기화
  Future<void> init() async {
    if (_isInitialized) return;

    // Android 설정
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS 설정
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    // 초기화 설정
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _notifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    _isInitialized = true;
  }

  /// 알림 탭 핸들러
  void _onNotificationTap(NotificationResponse response) {
    // 알림 탭 시 처리
  }

  /// 세션 완료 알림
  Future<void> showSessionCompleted() async {
    await _notifications.show(
      0,
      '🎉 세션 완료!',
      '훌륭해요! 집중 세션을 완료했습니다.',
      _getNotificationDetails(),
    );
  }

  /// 집중 이탈 알림
  Future<void> showDistractionAlert() async {
    await _notifications.show(
      1,
      '집중 세션 중이에요 👀',
      '돌아올까요? 탭하여 계속하기',
      _getNotificationDetails(),
    );
  }

  /// 휴식 끝 알림
  Future<void> showBreakEnded() async {
    await _notifications.show(
      2,
      '휴식 시간 종료 ⏰',
      '다시 집중할 준비가 되셨나요?',
      _getNotificationDetails(),
    );
  }

  /// 알림 상세 설정
  NotificationDetails _getNotificationDetails() {
    return const NotificationDetails(
      android: AndroidNotificationDetails(
        'focusflow_channel',
        'FocusFlow 알림',
        channelDescription: 'FocusFlow 앱 알림',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );
  }

  /// 모든 알림 취소
  Future<void> cancelAll() async {
    await _notifications.cancelAll();
  }

  /// 특정 알림 취소
  Future<void> cancel(int id) async {
    await _notifications.cancel(id);
  }
}




