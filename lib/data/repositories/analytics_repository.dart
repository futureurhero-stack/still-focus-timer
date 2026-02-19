import '../local/database_service.dart';
import '../models/models.dart';

/// 통계 및 분석 데이터를 관리하는 Repository
class AnalyticsRepository {
  final DatabaseService _db;

  AnalyticsRepository({DatabaseService? db}) : _db = db ?? DatabaseService();

  /// 특정 날짜의 통계 계산
  Future<DailyStatsModel> getDailyStats(DateTime date) async {
    final sessions = await _db.getSessionsByDate(date);
    
    if (sessions.isEmpty) {
      return DailyStatsModel.empty(date);
    }

    final completedSessions = sessions.where((s) => s.isCompleted).length;
    final givenUpSessions = sessions.where((s) => s.wasGivenUp).length;
    
    // 총 집중 시간 계산 (분)
    final totalSeconds = sessions.fold<int>(
      0,
      (sum, s) => sum + s.actualDurationSeconds,
    );
    final totalMinutes = (totalSeconds / 60).round();

    // 평균 완료율 계산
    final avgCompletionRate = sessions.isEmpty
        ? 0.0
        : sessions.fold<double>(0, (sum, s) => sum + s.completionRate) /
            sessions.length;

    // 가장 집중이 잘 된 시간대 찾기
    final hourCounts = <int, int>{};
    for (final session in sessions.where((s) => s.isCompleted)) {
      final hour = session.startTime.hour;
      hourCounts[hour] = (hourCounts[hour] ?? 0) + 1;
    }
    
    int? bestHour;
    int maxCount = 0;
    hourCounts.forEach((hour, count) {
      if (count > maxCount) {
        maxCount = count;
        bestHour = hour;
      }
    });

    // 총 집중 이탈 횟수
    final totalDistractions = sessions.fold<int>(
      0,
      (sum, s) => sum + s.distractionCount,
    );

    return DailyStatsModel(
      date: date,
      totalSessions: sessions.length,
      completedSessions: completedSessions,
      givenUpSessions: givenUpSessions,
      totalFocusMinutes: totalMinutes,
      bestFocusHour: bestHour,
      averageCompletionRate: avgCompletionRate,
      totalDistractions: totalDistractions,
    );
  }

  /// 오늘의 통계 가져오기
  Future<DailyStatsModel> getTodayStats() {
    return getDailyStats(DateTime.now());
  }

  /// 주간 통계 가져오기
  Future<List<DailyStatsModel>> getWeekStats() async {
    final now = DateTime.now();
    final stats = <DailyStatsModel>[];
    
    for (int i = 6; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailyStats = await getDailyStats(date);
      stats.add(dailyStats);
    }
    
    return stats;
  }

  /// 월간 통계 가져오기
  Future<List<DailyStatsModel>> getMonthStats() async {
    final now = DateTime.now();
    final stats = <DailyStatsModel>[];
    
    for (int i = 29; i >= 0; i--) {
      final date = now.subtract(Duration(days: i));
      final dailyStats = await getDailyStats(date);
      stats.add(dailyStats);
    }
    
    return stats;
  }

  /// 집중 패턴 분석 - 시간대별 성공률
  Future<Map<int, double>> getHourlySuccessRate() async {
    final sessions = await _db.getAllSessions();
    final hourlyTotal = <int, int>{};
    final hourlySuccess = <int, int>{};

    for (final session in sessions) {
      final hour = session.startTime.hour;
      hourlyTotal[hour] = (hourlyTotal[hour] ?? 0) + 1;
      if (session.isSuccessful) {
        hourlySuccess[hour] = (hourlySuccess[hour] ?? 0) + 1;
      }
    }

    final result = <int, double>{};
    hourlyTotal.forEach((hour, total) {
      final success = hourlySuccess[hour] ?? 0;
      result[hour] = total > 0 ? success / total : 0;
    });

    return result;
  }

  /// 요일별 성공률 분석
  Future<Map<int, double>> getWeekdaySuccessRate() async {
    final sessions = await _db.getAllSessions();
    final weekdayTotal = <int, int>{};
    final weekdaySuccess = <int, int>{};

    for (final session in sessions) {
      final weekday = session.startTime.weekday;
      weekdayTotal[weekday] = (weekdayTotal[weekday] ?? 0) + 1;
      if (session.isSuccessful) {
        weekdaySuccess[weekday] = (weekdaySuccess[weekday] ?? 0) + 1;
      }
    }

    final result = <int, double>{};
    weekdayTotal.forEach((weekday, total) {
      final success = weekdaySuccess[weekday] ?? 0;
      result[weekday] = total > 0 ? success / total : 0;
    });

    return result;
  }

  /// 최적의 집중 시간대 추천
  Future<int?> getBestFocusHour() async {
    final hourlyRate = await getHourlySuccessRate();
    if (hourlyRate.isEmpty) return null;

    int? bestHour;
    double maxRate = 0;

    hourlyRate.forEach((hour, rate) {
      if (rate > maxRate) {
        maxRate = rate;
        bestHour = hour;
      }
    });

    return bestHour;
  }

  /// 추천 세션 길이 계산
  Future<int> getRecommendedDuration() async {
    final sessions = await _db.getAllSessions();
    final completedSessions = sessions.where((s) => s.isCompleted).toList();

    if (completedSessions.isEmpty) {
      return 10; // 기본값
    }

    // 성공한 세션들의 평균 시간 계산
    final avgSeconds = completedSessions.fold<int>(
          0,
          (sum, s) => sum + s.actualDurationSeconds,
        ) ~/
        completedSessions.length;

    // 5분 단위로 반올림
    final minutes = (avgSeconds / 60).round();
    return ((minutes / 5).round() * 5).clamp(5, 40);
  }

  /// 일일 스토리 생성을 위한 데이터 수집
  Future<Map<String, dynamic>> getDailyStoryData() async {
    final today = DateTime.now();
    final sessions = await _db.getSessionsByDate(today);
    final stats = await getDailyStats(today);

    // 연기한 횟수 (포기 후 다시 시작한 경우)
    int postponeCount = 0;
    SessionModel? lastSession;
    for (final session in sessions) {
      if (lastSession != null && lastSession.wasGivenUp) {
        postponeCount++;
      }
      lastSession = session;
    }

    return {
      'totalSessions': stats.totalSessions,
      'completedSessions': stats.completedSessions,
      'totalFocusMinutes': stats.totalFocusMinutes,
      'bestFocusHour': stats.bestFocusHour,
      'postponeCount': postponeCount,
      'averageCompletionRate': stats.averageCompletionRate,
      'sessions': sessions.map((s) => s.toJson()).toList(),
    };
  }
}

