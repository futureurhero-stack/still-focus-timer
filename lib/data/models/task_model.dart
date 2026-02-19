import 'task_status.dart';

/// 작업을 나타내는 모델
class TaskModel {
  /// 고유 ID
  final String id;
  
  /// 작업 설명
  final String description;
  
  /// 작업 상태
  final TaskStatus status;
  
  /// 작업 생성 시간
  final DateTime createdAt;
  
  /// 마지막 사용 시간 (최근 작업 추천용)
  final DateTime lastUsedAt;
  
  /// 이 작업으로 완료한 세션 수
  final int sessionCount;

  const TaskModel({
    required this.id,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.lastUsedAt,
    this.sessionCount = 0,
  });

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'description': description,
      'status': status.index,
      'createdAt': createdAt.toIso8601String(),
      'lastUsedAt': lastUsedAt.toIso8601String(),
      'sessionCount': sessionCount,
    };
  }

  /// JSON에서 생성
  factory TaskModel.fromJson(Map<String, dynamic> json) {
    return TaskModel(
      id: json['id'] as String,
      description: json['description'] as String,
      status: TaskStatus.values[json['status'] as int],
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUsedAt: DateTime.parse(json['lastUsedAt'] as String),
      sessionCount: json['sessionCount'] as int? ?? 0,
    );
  }

  /// 복사본 생성
  TaskModel copyWith({
    String? id,
    String? description,
    TaskStatus? status,
    DateTime? createdAt,
    DateTime? lastUsedAt,
    int? sessionCount,
  }) {
    return TaskModel(
      id: id ?? this.id,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      lastUsedAt: lastUsedAt ?? this.lastUsedAt,
      sessionCount: sessionCount ?? this.sessionCount,
    );
  }

  @override
  String toString() {
    return 'TaskModel(id: $id, description: $description, status: $status)';
  }
}




