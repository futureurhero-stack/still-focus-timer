import 'emotion_type.dart';
import 'give_up_reason.dart';

/// 집중 세션을 나타내는 모델
class SessionModel {
  /// 고유 ID
  final String id;
  
  /// 세션 시작 시간
  final DateTime startTime;
  
  /// 세션 종료 시간 (null이면 진행 중)
  final DateTime? endTime;
  
  /// 설정된 세션 길이 (분)
  final int plannedDuration;
  
  /// 실제 진행된 시간 (초)
  final int actualDurationSeconds;
  
  /// 세션 시작 시 선택한 감정
  final EmotionType emotion;
  
  /// 수행한 작업 내용
  final String? taskDescription;
  
  /// 세션 완료 여부
  final bool isCompleted;
  
  /// 포기한 경우 이유
  final GiveUpReason? giveUpReason;
  
  /// 회고 내용
  final String? reflection;
  
  /// 백그라운드로 전환한 횟수 (집중 이탈 감지)
  final int distractionCount;
  
  /// 세션 생성일
  final DateTime createdAt;

  const SessionModel({
    required this.id,
    required this.startTime,
    this.endTime,
    required this.plannedDuration,
    required this.actualDurationSeconds,
    required this.emotion,
    this.taskDescription,
    required this.isCompleted,
    this.giveUpReason,
    this.reflection,
    this.distractionCount = 0,
    required this.createdAt,
  });

  /// 세션이 진행 중인지 확인
  bool get isInProgress => endTime == null;

  /// 완료율 (0.0 ~ 1.0)
  double get completionRate {
    final plannedSeconds = plannedDuration * 60;
    if (plannedSeconds == 0) return 0;
    return (actualDurationSeconds / plannedSeconds).clamp(0.0, 1.0);
  }

  /// 세션이 성공적으로 완료되었는지 (80% 이상 진행)
  bool get isSuccessful => isCompleted && completionRate >= 0.8;

  /// 포기했는지 여부
  bool get wasGivenUp => giveUpReason != null;

  /// 실제 진행 시간을 Duration으로 반환
  Duration get actualDuration => Duration(seconds: actualDurationSeconds);

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'startTime': startTime.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'plannedDuration': plannedDuration,
      'actualDurationSeconds': actualDurationSeconds,
      'emotion': emotion.index,
      'taskDescription': taskDescription,
      'isCompleted': isCompleted,
      'giveUpReason': giveUpReason?.index,
      'reflection': reflection,
      'distractionCount': distractionCount,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// JSON에서 생성
  factory SessionModel.fromJson(Map<String, dynamic> json) {
    return SessionModel(
      id: json['id'] as String,
      startTime: DateTime.parse(json['startTime'] as String),
      endTime: json['endTime'] != null
          ? DateTime.parse(json['endTime'] as String)
          : null,
      plannedDuration: json['plannedDuration'] as int,
      actualDurationSeconds: json['actualDurationSeconds'] as int,
      emotion: EmotionType.values[json['emotion'] as int],
      taskDescription: json['taskDescription'] as String?,
      isCompleted: json['isCompleted'] as bool,
      giveUpReason: json['giveUpReason'] != null
          ? GiveUpReason.values[json['giveUpReason'] as int]
          : null,
      reflection: json['reflection'] as String?,
      distractionCount: json['distractionCount'] as int? ?? 0,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  /// 복사본 생성
  SessionModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
    int? plannedDuration,
    int? actualDurationSeconds,
    EmotionType? emotion,
    String? taskDescription,
    bool? isCompleted,
    GiveUpReason? giveUpReason,
    String? reflection,
    int? distractionCount,
    DateTime? createdAt,
  }) {
    return SessionModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      plannedDuration: plannedDuration ?? this.plannedDuration,
      actualDurationSeconds: actualDurationSeconds ?? this.actualDurationSeconds,
      emotion: emotion ?? this.emotion,
      taskDescription: taskDescription ?? this.taskDescription,
      isCompleted: isCompleted ?? this.isCompleted,
      giveUpReason: giveUpReason ?? this.giveUpReason,
      reflection: reflection ?? this.reflection,
      distractionCount: distractionCount ?? this.distractionCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  String toString() {
    return 'SessionModel(id: $id, emotion: $emotion, '
        'duration: $actualDurationSeconds/$plannedDuration min, '
        'completed: $isCompleted)';
  }
}




