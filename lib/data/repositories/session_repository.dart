import 'package:uuid/uuid.dart';
import '../local/database_service.dart';
import '../models/models.dart';

/// 세션 데이터를 관리하는 Repository
class SessionRepository {
  final DatabaseService _db;
  final _uuid = const Uuid();

  SessionRepository({DatabaseService? db}) : _db = db ?? DatabaseService();

  /// 새 세션 생성
  Future<SessionModel> createSession({
    required EmotionType emotion,
    required int plannedDuration,
    String? taskDescription,
  }) async {
    final now = DateTime.now();
    final session = SessionModel(
      id: _uuid.v4(),
      startTime: now,
      plannedDuration: plannedDuration,
      actualDurationSeconds: 0,
      emotion: emotion,
      taskDescription: taskDescription,
      isCompleted: false,
      createdAt: now,
    );

    await _db.saveSession(session);
    return session;
  }

  /// 세션 업데이트
  Future<SessionModel> updateSession(SessionModel session) async {
    await _db.saveSession(session);
    return session;
  }

  /// 세션 완료
  Future<SessionModel> completeSession({
    required String sessionId,
    required int actualDurationSeconds,
    String? reflection,
  }) async {
    final sessions = await _db.getAllSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    
    if (index < 0) {
      throw Exception('세션을 찾을 수 없습니다: $sessionId');
    }

    final updatedSession = sessions[index].copyWith(
      endTime: DateTime.now(),
      actualDurationSeconds: actualDurationSeconds,
      isCompleted: true,
      reflection: reflection,
    );

    await _db.saveSession(updatedSession);
    return updatedSession;
  }

  /// 세션 포기
  Future<SessionModel> giveUpSession({
    required String sessionId,
    required int actualDurationSeconds,
    required GiveUpReason reason,
  }) async {
    final sessions = await _db.getAllSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    
    if (index < 0) {
      throw Exception('세션을 찾을 수 없습니다: $sessionId');
    }

    final updatedSession = sessions[index].copyWith(
      endTime: DateTime.now(),
      actualDurationSeconds: actualDurationSeconds,
      isCompleted: false,
      giveUpReason: reason,
    );

    await _db.saveSession(updatedSession);
    return updatedSession;
  }

  /// 집중 이탈 횟수 증가
  Future<SessionModel> incrementDistraction(String sessionId) async {
    final sessions = await _db.getAllSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    
    if (index < 0) {
      throw Exception('세션을 찾을 수 없습니다: $sessionId');
    }

    final updatedSession = sessions[index].copyWith(
      distractionCount: sessions[index].distractionCount + 1,
    );

    await _db.saveSession(updatedSession);
    return updatedSession;
  }

  /// 회고 추가
  Future<SessionModel> addReflection({
    required String sessionId,
    required String reflection,
  }) async {
    final sessions = await _db.getAllSessions();
    final index = sessions.indexWhere((s) => s.id == sessionId);
    
    if (index < 0) {
      throw Exception('세션을 찾을 수 없습니다: $sessionId');
    }

    final updatedSession = sessions[index].copyWith(
      reflection: reflection,
    );

    await _db.saveSession(updatedSession);
    return updatedSession;
  }

  /// 모든 세션 가져오기
  Future<List<SessionModel>> getAllSessions() {
    return _db.getAllSessions();
  }

  /// 오늘의 세션 가져오기
  Future<List<SessionModel>> getTodaySessions() {
    return _db.getSessionsByDate(DateTime.now());
  }

  /// 특정 날짜의 세션 가져오기
  Future<List<SessionModel>> getSessionsByDate(DateTime date) {
    return _db.getSessionsByDate(date);
  }

  /// 주간 세션 가져오기
  Future<List<SessionModel>> getWeekSessions() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final start = DateTime(weekStart.year, weekStart.month, weekStart.day);
    final end = DateTime(now.year, now.month, now.day, 23, 59, 59);
    return _db.getSessionsByDateRange(start, end);
  }

  /// 세션 삭제
  Future<void> deleteSession(String id) {
    return _db.deleteSession(id);
  }
}




