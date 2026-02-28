import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/analytics/app_analytics.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/models/emotion_type.dart';

/// 회고 화면
class ReflectionScreen extends StatefulWidget {
  final String sessionId;
  final int actualDuration;
  final bool isCompleted;

  const ReflectionScreen({
    super.key,
    required this.sessionId,
    required this.actualDuration,
    required this.isCompleted,
  });

  @override
  State<ReflectionScreen> createState() => _ReflectionScreenState();
}

class _ReflectionScreenState extends State<ReflectionScreen> {
  final _textController = TextEditingController();
  final _sessionRepository = SessionRepository();
  bool _isSaving = false;

  bool _isKorean(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ko';

  @override
  void initState() {
    super.initState();
    AppAnalytics.logScreenView(screenName: AppAnalytics.screenReflection);
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _selectTask(String description) {
    _textController.text = description;
  }

  Future<void> _saveReflection() async {
    if (_isSaving) return;

    setState(() => _isSaving = true);

    try {
      final reflection = _textController.text.trim();
      if (reflection.isNotEmpty && widget.sessionId.isNotEmpty) {
        await _sessionRepository.addReflection(
          sessionId: widget.sessionId,
          reflection: reflection,
        );
      }
      _goHome();
    } catch (e) {
      setState(() => _isSaving = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save: $e')),
        );
      }
    }
  }

  void _skip() {
    _goHome();
  }

  void _goHome() {
    context.goNamed('home');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          // 1) Soft wave background
          const _SoftWaveBackground(),

          // 2) Content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  // Header
                  _buildHeader(),
                  const SizedBox(height: 32),

                  // Result card
                  _buildResultCard(),
                  const SizedBox(height: 32),

                  // Reflection Group
                  _buildReflectionSection(),

                  const SizedBox(height: 48),

                  // Buttons
                  _buildButtons(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: widget.isCompleted
                    ? const Color(0xFF10B981).withValues(alpha: 0.12)
                    : AppColors.accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                widget.isCompleted ? Icons.auto_awesome_rounded : Icons.stars_rounded,
                color: widget.isCompleted ? const Color(0xFF10B981) : AppColors.accent,
                size: 28,
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isKorean(context)
                      ? (widget.isCompleted ? '완벽한 집중이었어요!' : '충분히 잘해냈어요')
                      : (widget.isCompleted ? 'Masterful Focus!' : 'Valuable Progress'),
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF121318),
                    letterSpacing: -0.8,
                  ),
                ),
                Text(
                  AppStrings.reflectionTitle(context),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF121318).withValues(alpha: 0.4),
                  ),
                ),
              ],
            ),
          ],
        )
            .animate()
            .fadeIn(duration: 400.ms)
            .slideX(begin: -0.1, end: 0),

        // Skip Button — 버튼 형태
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _skip,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF121318).withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                AppStrings.reflectionSkip(context),
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF121318).withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        )
            .animate()
            .fadeIn(duration: 400.ms, delay: 200.ms),
      ],
    );
  }

  Widget _buildResultCard() {
    final duration = Duration(seconds: widget.actualDuration);
    final formattedTime = AppDateUtils.formatDurationLong(duration);
    final themeColor = widget.isCompleted ? const Color(0xFF10B981) : AppColors.accent;
    final glowB = themeColor.withValues(alpha: 0.05);

    return Container(
      width: double.infinity,
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
        border: Border.all(color: Colors.white.withValues(alpha: 0.75), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.055),
            blurRadius: 30,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: Stack(
          children: [
            // Background glow
            Positioned(
              left: -40,
              top: -40,
              child: Container(
                width: 160,
                height: 160,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: themeColor.withValues(alpha: 0.08),
                ),
              ),
            ),

            // Bottom accent bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Container(
                height: 4,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      themeColor.withValues(alpha: 0.7),
                      themeColor.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                children: [
                  Text(
                    _isKorean(context) ? '총 집중 시간' : 'Total Focus Time',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF121318).withValues(alpha: 0.35),
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    formattedTime,
                    style: TextStyle(
                      fontSize: 42,
                      fontWeight: FontWeight.w900,
                      color: themeColor,
                      letterSpacing: -1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildStatusBadge(
                        Localizations.localeOf(context).languageCode == 'ko'
                            ? (widget.isCompleted ? '목표 달성' : '세션 종료')
                            : (widget.isCompleted ? 'Goal Reached' : 'Session Ended'),
                        themeColor,
                      ),
                    ],
                  ),
                  const SizedBox(height: 12), // Padding for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
    )
        .animate()
        .fadeIn(duration: 500.ms, delay: 100.ms)
        .scale(begin: const Offset(0.95, 0.95), curve: Curves.easeOutBack);
  }

  Widget _buildStatusBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(100),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            widget.isCompleted ? Icons.check_circle_rounded : Icons.info_rounded,
            size: 16,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReflectionSection() {
    const glowB = AppColors.accent;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            AppStrings.reflectionQuestion(context).toUpperCase(),
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
              color: const Color(0xFF121318).withValues(alpha: 0.35),
              letterSpacing: 1.2,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFFFFFFFF),
                glowB.withValues(alpha: 0.04),
              ],
            ),
            borderRadius: BorderRadius.circular(30),
            border: Border.all(color: Colors.white.withValues(alpha: 0.75), width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.055),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30),
            child: Stack(
              children: [
                // Background glow
                Positioned(
                  left: -30,
                  top: -30,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: glowB.withValues(alpha: 0.06),
                    ),
                  ),
                ),
                // Bottom accent bar
                Positioned(
                  left: 20,
                  right: 20,
                  bottom: 0,
                  child: Container(
                    height: 3,
                    decoration: BoxDecoration(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(99)),
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          glowB.withValues(alpha: 0.6),
                          glowB.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 1) TextField
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: TextField(
                        controller: _textController,
                        maxLines: 4,
                        style: const TextStyle(
                          color: Color(0xFF121318),
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: AppStrings.reflectionHint(context),
                          hintStyle: TextStyle(
                            color: const Color(0xFF121318).withValues(alpha: 0.25),
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),

                    // 2) Suggestions — Overwhelmed, Distracted, Low Energy, In the Zone 순서
                    Divider(
                      height: 1,
                      color: const Color(0xFF121318).withValues(alpha: 0.05),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppStrings.recentTasks(context),
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF121318).withValues(alpha: 0.4),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              EmotionType.stressed,
                              EmotionType.tired,
                              EmotionType.sleepy,
                              EmotionType.good,
                            ].map((emotion) {
                              return GestureDetector(
                                onTap: () => _selectTask(emotion.label(context)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF7F8FC),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(
                                      color: const Color(0xFF121318).withValues(alpha: 0.05),
                                    ),
                                  ),
                                  child: Text(
                                    emotion.label(context),
                                    style: const TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: Color(0xFF121318),
                                    ),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: 400.ms, delay: 200.ms)
        .slideY(begin: 0.1, end: 0);
  }

    Widget _buildButtons() {
    return Column(
      children: [
        // Save Button
        Container(
          width: double.infinity,
          height: 64,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            boxShadow: [
              BoxShadow(
                color: AppColors.accent.withValues(alpha: 0.3),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: _isSaving ? AppColors.accent.withValues(alpha: 0.6) : AppColors.accent,
            borderRadius: BorderRadius.circular(32),
            child: InkWell(
              onTap: _isSaving ? null : _saveReflection,
              borderRadius: BorderRadius.circular(32),
              child: Center(
                child: _isSaving
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : Text(
                        AppStrings.reflectionSave(context),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ),
        ).animate()
            .fadeIn(duration: 400.ms, delay: 400.ms)
            .slideY(begin: 0.1, end: 0),

        const SizedBox(height: 20),

        // Back to Home — 버튼 형태
        Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: _goHome,
            borderRadius: BorderRadius.circular(24),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: const Color(0xFF121318).withValues(alpha: 0.12),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                Localizations.localeOf(context).languageCode == 'ko'
                    ? '홈으로 돌아가기'
                    : 'Back to Home',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF121318).withValues(alpha: 0.6),
                ),
              ),
            ),
          ),
        ).animate()
            .fadeIn(duration: 400.ms, delay: 500.ms),
      ],
    );
  }
}

// Replicating Home's background for visual harmony
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
        const Color(0xFF12A594).withValues(alpha: 0.05),
        const Color(0xFF12A594).withValues(alpha: 0.01),
      ],
    ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final paint1 = Paint()
      ..shader = gradient1
      ..style = PaintingStyle.fill;

    // Wave 1
    final p1 = Path();
    p1.moveTo(0, size.height * 0.7);
    p1.quadraticBezierTo(
      size.width * 0.25,
      size.height * 0.5,
      size.width * 0.50,
      size.height * 0.7,
    );
    p1.quadraticBezierTo(
      size.width * 0.75,
      size.height * 0.9,
      size.width,
      size.height * 0.7,
    );
    p1.lineTo(size.width, size.height);
    p1.lineTo(0, size.height);
    p1.close();
    canvas.drawPath(p1, paint1);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

