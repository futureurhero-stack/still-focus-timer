import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../core/analytics/app_analytics.dart';
import '../core/constants/app_colors.dart';
import '../core/constants/app_strings.dart';
import '../core/providers/default_duration_provider.dart';
import '../shared/widgets/gradient_button.dart';
import '../data/models/emotion_type.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  _Quote? _todayQuote;

  @override
  void initState() {
    super.initState();
    _loadQuoteOfTheDay();
    AppAnalytics.logScreenView(screenName: AppAnalytics.screenHome);
  }

  Future<void> _loadQuoteOfTheDay() async {
    try {
      final raw = await rootBundle.loadString(
        'assets/quotes/still_schopenhauer_60.json',
      );
      final List<dynamic> jsonList = jsonDecode(raw) as List<dynamic>;
      if (jsonList.isEmpty) return;

      final quotes = jsonList
          .map((e) => _Quote.fromJson(e as Map<String, dynamic>))
          .toList();

      // 날짜를 기반으로 시드를 만든 뒤, 그날에만 고정된 랜덤 인덱스를 사용
      final now = DateTime.now();
      final seed = now.year * 10000 + now.month * 100 + now.day;
      final random = Random(seed);
      final index = random.nextInt(quotes.length);

      setState(() {
        _todayQuote = quotes[index];
      });
    } catch (_) {
      // 실패해도 홈 화면은 정상 동작해야 하므로 조용히 무시합니다.
    }
  }

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFFF7F8FC);

    return Scaffold(
      backgroundColor: bgTop,
      // ✅ body를 Stack으로 감싼 "완성본"
      body: Stack(
        children: [
          // 1) 아주 은은한 웨이브 배경(맨 뒤)
          const _SoftWaveBackground(),

          // 2) 실제 화면 콘텐츠(맨 앞)
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 22),
                  Text(
                    "Still: Focus Timer",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF121318).withValues(alpha:0.38),
                      letterSpacing: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    AppStrings.howAreYouFeelingNow(context),
                    style: const TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF121318),
                      height: 1.12,
                    ),
                  ),
                  const SizedBox(height: 26),

                  Expanded(
                    child: GridView(
                      padding: const EdgeInsets.only(bottom: 8),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 18,
                        crossAxisSpacing: 18,
                        childAspectRatio: 1.0,
                      ),
                      children: [
                        _EmotionCard(
                          icon: Icons.sentiment_very_dissatisfied_rounded,
                          title: AppStrings.emotionStressed(context),
                          subtitle: AppStrings.emotionStressedDesc(context),
                          duration: "10–15 min",
                          accent: AppColors.emotionStressed,
                          onTap: () => _goTimer(
                            duration: 15,
                            task:
                                "${AppStrings.emotionStressed(context)} ${Localizations.localeOf(context).languageCode == 'ko' ? '세션' : 'session'}",
                            emotion: EmotionType.stressed,
                          ),
                        ),
                        _EmotionCard(
                          icon: Icons.blur_on_rounded,
                          title: AppStrings.emotionTired(context),
                          subtitle: AppStrings.emotionTiredDesc(context),
                          duration: "15–20 min",
                          accent: AppColors.emotionTired,
                          onTap: () => _goTimer(
                            duration: 20,
                            task:
                                "${AppStrings.emotionTired(context)} ${Localizations.localeOf(context).languageCode == 'ko' ? '세션' : 'session'}",
                            emotion: EmotionType.tired,
                          ),
                        ),
                        _EmotionCard(
                          icon: Icons.battery_3_bar_rounded,
                          title: AppStrings.emotionSleepy(context),
                          subtitle: AppStrings.emotionSleepyDesc(context),
                          duration: "5–10 min",
                          accent: AppColors.emotionSleepy,
                          onTap: () => _goTimer(
                            duration: 10,
                            task:
                                "${AppStrings.emotionSleepy(context)} ${Localizations.localeOf(context).languageCode == 'ko' ? '세션' : 'session'}",
                            emotion: EmotionType.sleepy,
                          ),
                        ),
                        _EmotionCard(
                          icon: Icons.track_changes_rounded,
                          title: AppStrings.emotionGood(context),
                          subtitle: AppStrings.emotionGoodDesc(context),
                          duration: "25 min",
                          accent: AppColors.emotionGood,
                          onTap: () => _goTimer(
                            duration: 25,
                            task: AppStrings.emotionGood(context),
                            emotion: EmotionType.good,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  if (_todayQuote != null) ...[
                    _QuoteBanner(quote: _todayQuote!),
                    const SizedBox(height: 14),
                  ],

                  // Quick actions: fixed 10min + default duration
                  Consumer(
                    builder: (context, ref, _) {
                      final defaultDuration = ref.watch(defaultDurationProvider);
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          GradientButton(
                            text:
                                '${AppStrings.quickStart(context)} 10 ${AppStrings.minutes(context)}',
                            onPressed: () =>
                                _goTimer(duration: 10, task: 'quick_start'),
                          ),
                          const SizedBox(height: 12),
                          GradientButton(
                            text:
                                '${AppStrings.defaultDuration(context)} • $defaultDuration ${AppStrings.minutes(context)}',
                            onPressed: () => _goTimer(
                              duration: defaultDuration,
                              task: 'start_my_routine',
                            ),
                          ),
                        ],
                      );
                    },
                  ),

                  const SizedBox(height: 18),
                ],
              ),
            ),
          ),
        ],
      ),

      bottomNavigationBar: _BottomNav(
        currentIndex: _navIndex,
        onTap: (i) {
          setState(() => _navIndex = i);
          if (i == 0) return; // Home
          if (i == 1) context.go('/analytics'); // Stats
          if (i == 2) context.go('/settings'); // Settings
        },
      ),
    );
  }

  void _goTimer({required int duration, String? task, EmotionType? emotion}) {
    final effectiveEmotion = emotion ?? EmotionType.good;
    if (task == 'quick_start') {
      AppAnalytics.logQuickStart(durationMinutes: duration);
    } else if (task == 'start_my_routine') {
      AppAnalytics.logStartMyRoutine(durationMinutes: duration);
    } else if (emotion != null) {
      AppAnalytics.logMoodSelected(emotion: emotion, durationMinutes: duration);
    }
    context.push(
      '/timer',
      extra: <String, dynamic>{
        'duration': duration,
        'task': task,
        'emotion': effectiveEmotion,
      },
    );
  }
}

class _Quote {
  final int id;
  final String author;
  final String title;
  final String subtitle;
  final String? authorKo;
  final String? titleKo;
  final String? subtitleKo;

  const _Quote({
    required this.id,
    required this.author,
    required this.title,
    required this.subtitle,
    this.authorKo,
    this.titleKo,
    this.subtitleKo,
  });

  factory _Quote.fromJson(Map<String, dynamic> json) {
    return _Quote(
      id: json['id'] as int,
      author: json['author'] as String? ?? '',
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      authorKo: json['authorKo'] as String?,
      titleKo: json['titleKo'] as String?,
      subtitleKo: json['subtitleKo'] as String?,
    );
  }
}

class _QuoteBanner extends StatelessWidget {
  final _Quote quote;

  const _QuoteBanner({required this.quote});

  @override
  Widget build(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    final useKo = isKo &&
        quote.titleKo != null &&
        quote.subtitleKo != null &&
        quote.authorKo != null;

    final displayTitle = useKo ? quote.titleKo! : quote.title;
    final displayAuthor = useKo ? quote.authorKo! : quote.author;
    final rawSubtitle = useKo ? quote.subtitleKo! : quote.subtitle;
    final cutIndex = rawSubtitle.lastIndexOf(' - ');
    final displaySubtitle =
        cutIndex > 0 ? rawSubtitle.substring(0, cutIndex).trim() : rawSubtitle;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.94),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            displayTitle,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF121318),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            displaySubtitle,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF121318).withValues(alpha:0.6),
              height: 1.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            '- $displayAuthor -',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF121318).withValues(alpha:0.45),
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}

/// ✅ 카드: "거의 화이트" + 포인트 컬러(아이콘/시간/바)만 사용해서 프리미엄 톤
class _EmotionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String duration;
  final Color accent;
  final VoidCallback onTap;

  const _EmotionCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.duration,
    required this.accent,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    const baseText = Color(0xFF121318);
    final subText = baseText.withValues(alpha:0.58);

    final glowA = accent.withValues(alpha:0.12);
    final glowB = accent.withValues(alpha:0.06);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFFFFF),
                glowB,
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha:0.75), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:0.055),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: Stack(
            children: [
              // 은은한 컬러 글로우
              Positioned(
                left: -24,
                top: -24,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: glowA,
                  ),
                ),
              ),

              // 하단 얇은 accent bar
              Positioned(
                left: 16,
                right: 16,
                bottom: 14,
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(99),
                    gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: [
                        accent.withValues(alpha:0.78),
                        accent.withValues(alpha:0.18),
                      ],
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 아이콘 배경 투명 + 시간은 아이콘 옆(우측)
                    Row(
                      children: [
                        SizedBox(
                          width: 46,
                          height: 46,
                          child: Icon(
                            icon,
                            size: 34,
                            color: baseText.withValues(alpha:0.90),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          duration,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: accent.withValues(alpha:0.92),
                            letterSpacing: 0.15,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: baseText,
                      ),
                    ),
                    const SizedBox(height: 6),

                    Expanded(
                      child: Text(
                        subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: subText,
                          height: 1.22,
                        ),
                      ),
                    ),

                    // accent bar와 겹치지 않도록 여백
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// _QuickStartButton removed and replaced by shared GradientButton

class _BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const _BottomNav({
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha:0.88),
        border: Border(top: BorderSide(color: Colors.black.withValues(alpha:0.06))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:0.045),
            blurRadius: 18,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: currentIndex,
        onTap: onTap,
        type: BottomNavigationBarType.fixed,
        elevation: 0,
        backgroundColor: Colors.transparent,
        selectedItemColor: const Color(0xFF121318),
        unselectedItemColor: const Color(0xFF121318).withValues(alpha:0.35),
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home_filled),
            label: AppStrings.navHome(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.bar_chart_rounded),
            label: AppStrings.navStats(context),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings_rounded),
            label: AppStrings.navSettings(context),
          ),
        ],
      ),
    );
  }
}

/// ✅ 하단 빈 공간을 "아주 은은하게" 채우는 웨이브 배경
class _SoftWaveBackground extends StatelessWidget {
  const _SoftWaveBackground();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFF7F8FC),
              Color(0xFFF3F5FB),
            ],
          ),
        ),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            height: 260,
            width: double.infinity,
            child: CustomPaint(
              painter: _WavePainter(),
            ),
          ),
        ),
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {

    final gradient1 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF12A594).withValues(alpha:0.08),
        const Color(0xFF12A594).withValues(alpha:0.02),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final gradient2 = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        const Color(0xFF12A594).withValues(alpha:0.05),
        const Color(0xFF12A594).withValues(alpha:0.01),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..shader = gradient2
      ..style = PaintingStyle.fill;

    // Wave 1
    final p1 = Path();
    p1.moveTo(0, size.height * 0.62);
    p1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.42,
      size.width * 0.50,
      size.height * 0.62,
    );
    p1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.82,
      size.width,
      size.height * 0.62,
    );
    p1.lineTo(size.width, size.height);
    p1.lineTo(0, size.height);
    p1.close();
    canvas.drawPath(p1, paint1);

    // Wave 2
    final p2 = Path();
    p2.moveTo(0, size.height * 0.76);
    p2.quadraticBezierTo(
      size.width * 0.28,
      size.height * 0.64,
      size.width * 0.55,
      size.height * 0.76,
    );
    p2.quadraticBezierTo(
      size.width * 0.80,
      size.height * 0.88,
      size.width,
      size.height * 0.76,
    );
    p2.lineTo(size.width, size.height);
    p2.lineTo(0, size.height);
    p2.close();
    canvas.drawPath(p2, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}