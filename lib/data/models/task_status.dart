/// 작업의 상태를 나타내는 enum
enum TaskStatus {
  /// 시작됨
  started,
  
  /// 진행 중
  inProgress,
  
  /// 완료됨
  completed,
}

/// TaskStatus에 대한 확장 메서드
extension TaskStatusExtension on TaskStatus {
  /// 상태 이름 반환
  String get label {
    switch (this) {
      case TaskStatus.started:
        return '시작';
      case TaskStatus.inProgress:
        return '진행 중';
      case TaskStatus.completed:
        return '완료';
    }
  }

  /// 다음 상태로 전환
  TaskStatus get next {
    switch (this) {
      case TaskStatus.started:
        return TaskStatus.inProgress;
      case TaskStatus.inProgress:
        return TaskStatus.completed;
      case TaskStatus.completed:
        return TaskStatus.completed;
    }
  }

  /// 완료 여부
  bool get isCompleted => this == TaskStatus.completed;
}




