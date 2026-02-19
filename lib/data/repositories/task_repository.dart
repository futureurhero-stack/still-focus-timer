import 'package:uuid/uuid.dart';
import '../local/database_service.dart';
import '../models/models.dart';

/// 작업 데이터를 관리하는 Repository
class TaskRepository {
  final DatabaseService _db;
  final _uuid = const Uuid();

  TaskRepository({DatabaseService? db}) : _db = db ?? DatabaseService();

  /// 새 작업 생성 또는 기존 작업 업데이트
  Future<TaskModel> createOrUpdateTask(String description) async {
    final tasks = await _db.getAllTasks();
    
    // 동일한 설명의 작업이 있는지 확인
    final existingIndex = tasks.indexWhere(
      (t) => t.description.toLowerCase() == description.toLowerCase(),
    );

    if (existingIndex >= 0) {
      // 기존 작업 업데이트
      final updatedTask = tasks[existingIndex].copyWith(
        lastUsedAt: DateTime.now(),
        sessionCount: tasks[existingIndex].sessionCount + 1,
      );
      await _db.saveTask(updatedTask);
      return updatedTask;
    }

    // 새 작업 생성
    final now = DateTime.now();
    final task = TaskModel(
      id: _uuid.v4(),
      description: description,
      status: TaskStatus.started,
      createdAt: now,
      lastUsedAt: now,
      sessionCount: 1,
    );

    await _db.saveTask(task);
    return task;
  }

  /// 작업 상태 업데이트
  Future<TaskModel> updateTaskStatus(String id, TaskStatus status) async {
    final tasks = await _db.getAllTasks();
    final index = tasks.indexWhere((t) => t.id == id);
    
    if (index < 0) {
      throw Exception('작업을 찾을 수 없습니다: $id');
    }

    final updatedTask = tasks[index].copyWith(
      status: status,
      lastUsedAt: DateTime.now(),
    );

    await _db.saveTask(updatedTask);
    return updatedTask;
  }

  /// 모든 작업 가져오기
  Future<List<TaskModel>> getAllTasks() {
    return _db.getAllTasks();
  }

  /// 최근 작업 가져오기
  Future<List<TaskModel>> getRecentTasks({int limit = 5}) {
    return _db.getRecentTasks(limit: limit);
  }

  /// 작업 삭제
  Future<void> deleteTask(String id) {
    return _db.deleteTask(id);
  }

  /// 작업 검색
  Future<List<TaskModel>> searchTasks(String query) async {
    final tasks = await _db.getAllTasks();
    final lowerQuery = query.toLowerCase();
    
    return tasks
        .where((t) => t.description.toLowerCase().contains(lowerQuery))
        .toList()
      ..sort((a, b) => b.lastUsedAt.compareTo(a.lastUsedAt));
  }
}




