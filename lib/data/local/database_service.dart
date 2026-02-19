import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

/// 로컬 데이터베이스 서비스
/// SharedPreferences를 사용하여 데이터를 저장합니다.
class DatabaseService {
  static const String _sessionsKey = 'sessions';
  static const String _tasksKey = 'tasks';
  static const String _settingsKey = 'settings';

  SharedPreferences? _prefs;

  /// 싱글톤 인스턴스
  static final DatabaseService _instance = DatabaseService._internal();
  factory DatabaseService() => _instance;
  DatabaseService._internal();

  /// 초기화
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  /// SharedPreferences 인스턴스 확인
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception('DatabaseService가 초기화되지 않았습니다. init()을 먼저 호출하세요.');
    }
    return _prefs!;
  }

  // ===== Session Methods =====

  /// 모든 세션 가져오기
  Future<List<SessionModel>> getAllSessions() async {
    final jsonString = prefs.getString(_sessionsKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => SessionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 세션 저장
  Future<void> saveSession(SessionModel session) async {
    final sessions = await getAllSessions();
    final index = sessions.indexWhere((s) => s.id == session.id);
    
    if (index >= 0) {
      sessions[index] = session;
    } else {
      sessions.add(session);
    }

    final jsonList = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(jsonList));
  }

  /// 여러 세션 저장
  Future<void> saveSessions(List<SessionModel> sessions) async {
    final jsonList = sessions.map((s) => s.toJson()).toList();
    await prefs.setString(_sessionsKey, jsonEncode(jsonList));
  }

  /// 특정 날짜의 세션 가져오기
  Future<List<SessionModel>> getSessionsByDate(DateTime date) async {
    final sessions = await getAllSessions();
    return sessions.where((session) {
      return session.startTime.year == date.year &&
          session.startTime.month == date.month &&
          session.startTime.day == date.day;
    }).toList();
  }

  /// 날짜 범위의 세션 가져오기
  Future<List<SessionModel>> getSessionsByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    final sessions = await getAllSessions();
    return sessions.where((session) {
      return session.startTime.isAfter(start.subtract(const Duration(seconds: 1))) &&
          session.startTime.isBefore(end.add(const Duration(seconds: 1)));
    }).toList();
  }

  /// 세션 삭제
  Future<void> deleteSession(String id) async {
    final sessions = await getAllSessions();
    sessions.removeWhere((s) => s.id == id);
    await saveSessions(sessions);
  }

  // ===== Task Methods =====

  /// 모든 작업 가져오기
  Future<List<TaskModel>> getAllTasks() async {
    final jsonString = prefs.getString(_tasksKey);
    if (jsonString == null) return [];

    final List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => TaskModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  /// 작업 저장
  Future<void> saveTask(TaskModel task) async {
    final tasks = await getAllTasks();
    final index = tasks.indexWhere((t) => t.id == task.id);
    
    if (index >= 0) {
      tasks[index] = task;
    } else {
      tasks.add(task);
    }

    final jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  /// 여러 작업 저장
  Future<void> saveTasks(List<TaskModel> tasks) async {
    final jsonList = tasks.map((t) => t.toJson()).toList();
    await prefs.setString(_tasksKey, jsonEncode(jsonList));
  }

  /// 최근 사용한 작업 가져오기 (상위 N개)
  Future<List<TaskModel>> getRecentTasks({int limit = 5}) async {
    final tasks = await getAllTasks();
    tasks.sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
    return tasks.take(limit).toList();
  }

  /// 작업 삭제
  Future<void> deleteTask(String id) async {
    final tasks = await getAllTasks();
    tasks.removeWhere((t) => t.id == id);
    await saveTasks(tasks);
  }

  // ===== Settings Methods =====

  /// 설정 값 가져오기
  Future<Map<String, dynamic>> getSettings() async {
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString == null) return {};
    return jsonDecode(jsonString) as Map<String, dynamic>;
  }

  /// 설정 값 저장
  Future<void> saveSettings(Map<String, dynamic> settings) async {
    await prefs.setString(_settingsKey, jsonEncode(settings));
  }

  /// 특정 설정 값 가져오기
  Future<T?> getSetting<T>(String key) async {
    final settings = await getSettings();
    return settings[key] as T?;
  }

  /// 특정 설정 값 저장
  Future<void> setSetting<T>(String key, T value) async {
    final settings = await getSettings();
    settings[key] = value;
    await saveSettings(settings);
  }

  /// 모든 데이터 삭제
  Future<void> clearAll() async {
    await prefs.clear();
  }
}




