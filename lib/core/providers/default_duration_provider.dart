import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/local/database_service.dart';

/// 기본 세션 시간 Provider
final defaultDurationProvider = StateNotifierProvider<DefaultDurationNotifier, int>(
  (ref) => DefaultDurationNotifier(),
);

/// 기본 세션 시간 Notifier
class DefaultDurationNotifier extends StateNotifier<int> {
  final _db = DatabaseService();

  DefaultDurationNotifier() : super(10) {
    _loadDuration();
  }

  /// 저장된 기본 시간 로드
  Future<void> _loadDuration() async {
    final duration = await _db.getSetting<int>('defaultDuration');
    if (duration != null) {
      state = duration;
    }
  }

  /// 기본 시간 업데이트
  Future<void> updateDuration(int duration) async {
    await _db.setSetting('defaultDuration', duration);
    state = duration;
  }
}




