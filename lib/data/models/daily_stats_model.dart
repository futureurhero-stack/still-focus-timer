/// 일일 통계를 나타내는 모델
class DailyStatsModel {
  /// 날짜
  final DateTime date;
  
  /// 총 세션 수
  final int totalSessions;
  
  /// 완료된 세션 수
  final int completedSessions;
  
  /// 포기한 세션 수
  final int givenUpSessions;
  
  /// 총 집중 시간 (분)
  final int totalFocusMinutes;
  
  /// 가장 집중이 잘 된 시간대 (0-23)
  final int? bestFocusHour;
  
  /// 평균 세션 완료율
  final double averageCompletionRate;
  
  /// 집중 이탈 횟수
  final int totalDistractions;

  const DailyStatsModel({
    required this.date,
    required this.totalSessions,
    required this.completedSessions,
    required this.givenUpSessions,
    required this.totalFocusMinutes,
    this.bestFocusHour,
    required this.averageCompletionRate,
    this.totalDistractions = 0,
  });

  /// 세션 완료율
  double get completionRate {
    if (totalSessions == 0) return 0;
    return completedSessions / totalSessions;
  }

  /// 세션이 있는지 확인
  bool get hasAnySession => totalSessions > 0;

  /// JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'totalSessions': totalSessions,
      'completedSessions': completedSessions,
      'givenUpSessions': givenUpSessions,
      'totalFocusMinutes': totalFocusMinutes,
      'bestFocusHour': bestFocusHour,
      'averageCompletionRate': averageCompletionRate,
      'totalDistractions': totalDistractions,
    };
  }

  /// JSON에서 생성
  factory DailyStatsModel.fromJson(Map<String, dynamic> json) {
    return DailyStatsModel(
      date: DateTime.parse(json['date'] as String),
      totalSessions: json['totalSessions'] as int,
      completedSessions: json['completedSessions'] as int,
      givenUpSessions: json['givenUpSessions'] as int,
      totalFocusMinutes: json['totalFocusMinutes'] as int,
      bestFocusHour: json['bestFocusHour'] as int?,
      averageCompletionRate: (json['averageCompletionRate'] as num).toDouble(),
      totalDistractions: json['totalDistractions'] as int? ?? 0,
    );
  }

  /// 빈 통계 생성
  factory DailyStatsModel.empty(DateTime date) {
    return DailyStatsModel(
      date: date,
      totalSessions: 0,
      completedSessions: 0,
      givenUpSessions: 0,
      totalFocusMinutes: 0,
      bestFocusHour: null,
      averageCompletionRate: 0,
      totalDistractions: 0,
    );
  }

  @override
  String toString() {
    return 'DailyStatsModel(date: $date, sessions: $totalSessions, '
        'completed: $completedSessions, focusMinutes: $totalFocusMinutes)';
  }
}




