import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _navIndex = 0;

  @override
  Widget build(BuildContext context) {
    const bgTop = Color(0xFFF7F8FC);
    const bgBottom = Color(0xFFF3F5FB);

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
                      color: const Color(0xFF121318).withOpacity(0.38),
                      letterSpacing: 1.25,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    "How are you feeling now?",
                    style: TextStyle(
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
                          icon: Icons.psychology_alt_rounded,
                          title: "Overwhelmed",
                          subtitle: "Too much on your mind?",
                          duration: "10–15 min",
                          accent: const Color(0xFFE44A6A), // deep rose
                          onTap: () => _goTimer(duration: 15, task: "Overwhelmed session"),
                        ),
                        _EmotionCard(
                          icon: Icons.blur_on_rounded,
                          title: "Distracted",
                          subtitle: "Hard to stay on task?",
                          duration: "15–20 min",
                          accent: const Color(0xFF3C6FF2), // refined blue
                          onTap: () => _goTimer(duration: 20, task: "Distracted session"),
                        ),
                        _EmotionCard(
                          icon: Icons.battery_3_bar_rounded,
                          title: "Low Energy",
                          subtitle: "Running low today?",
                          duration: "5–10 min",
                          accent: const Color(0xFF6E5CF6), // refined violet
                          onTap: () => _goTimer(duration: 10, task: "Low energy session"),
                        ),
                        _EmotionCard(
                          icon: Icons.track_changes_rounded,
                          title: "In the Zone",
                          subtitle: "Ready to dive in?",
                          duration: "25 min",
                          accent: const Color(0xFF12A594), // premium teal
                          onTap: () => _goTimer(duration: 25, task: "In the Zone"),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  _QuickStartButton(
                    label: "Quick Start 10 min",
                    onTap: () => _goTimer(duration: 10, task: "Quick Start"),
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
          if (i == 0) return;
          if (i == 1) context.go('/analytics');
          if (i == 2) _goTimer(duration: 25, task: "Focus");
          if (i == 3) context.go('/settings');
        },
      ),
    );
  }

  void _goTimer({required int duration, String? task}) {
    // EmotionType enum을 건드리지 않기 위해 emotion은 전달하지 않습니다.
    // 라우터에서 EmotionType.good로 기본 처리됩니다.
    context.push(
      '/timer',
      extra: <String, dynamic>{
        'duration': duration,
        'task': task,
      },
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
    final subText = baseText.withOpacity(0.58);

    final glowA = accent.withOpacity(0.12);
    final glowB = accent.withOpacity(0.06);

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
            border: Border.all(color: Colors.white.withOpacity(0.75), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.055),
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
                        accent.withOpacity(0.78),
                        accent.withOpacity(0.18),
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
                            color: baseText.withOpacity(0.90),
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
                            color: accent.withOpacity(0.92),
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

class _QuickStartButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _QuickStartButton({
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(30),
        onTap: onTap,
        child: Ink(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF2A2B31),
                Color(0xFF141519),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.16),
                blurRadius: 28,
                offset: const Offset(0, 16),
              ),
            ],
          ),
          child: Center(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                letterSpacing: 0.15,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
        color: Colors.white.withOpacity(0.88),
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.06))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
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
        unselectedItemColor: const Color(0xFF121318).withOpacity(0.35),
        selectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
        unselectedLabelStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.bar_chart_rounded), label: 'Stats'),
          BottomNavigationBarItem(icon: Icon(Icons.timer_rounded), label: 'Focus'),
          BottomNavigationBarItem(icon: Icon(Icons.person_rounded), label: 'Profile'),
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
    // 아주 얕은 웨이브 (프리미엄 느낌: "보일 듯 말 듯")
    final paint1 = Paint()
      ..color = const Color(0xFF121318).withOpacity(0.025)
      ..style = PaintingStyle.fill;

    final paint2 = Paint()
      ..color = const Color(0xFF121318).withOpacity(0.018)
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

    // Wave 2 (조금 더 아래, 더 옅게)
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