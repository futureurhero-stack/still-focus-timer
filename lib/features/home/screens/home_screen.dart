import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/providers/default_duration_provider.dart';
import '../../../data/models/emotion_type.dart';
import '../../../shared/widgets/mood_card.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Home screen - 새로운 디자인 (이미지 기반)
/// - 헤더: "Still: Focus Timer"
/// - 제목: "How are you feeling now?"
/// - 2x2 그리드의 감정 카드
/// - Quick Start 버튼
/// - 하단 네비게이션 바
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  EmotionType? _selectedEmotion;

  /// Quick Start 버튼 텍스트 생성
  String _getQuickStartText() {
    final defaultDuration = ref.read(defaultDurationProvider);
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    return isKo ? 'Quick Start $defaultDuration분' : 'Quick Start ${defaultDuration}m';
  }

  /// 감정 선택 핸들러
  void _onEmotionSelected(EmotionType emotion) {
    setState(() {
      _selectedEmotion = _selectedEmotion == emotion ? null : emotion;
    });
  }

  /// Quick Start 버튼 핸들러
  void _onQuickStart() {
    final duration = _selectedEmotion?.recommendedDuration ?? 
                    ref.read(defaultDurationProvider);
    final emotion = _selectedEmotion ?? EmotionType.good;
    
    context.pushNamed('timer', extra: {
      'emotion': emotion,
      'duration': duration,
      'task': null,
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Container(
          // 부드러운 그라데이션 배경 (이미지 기반)
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFFFFBF7), // 거의 흰색
                Color(0xFFF5F0EB), // 연한 라벤더/베이지
              ],
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 32),
                
                // 헤더: "Still: Focus Timer"
                _buildHeader(),
                
                const SizedBox(height: 48),
                
                // 제목: "How are you feeling now?"
                _buildTitle(),
                
                const SizedBox(height: 32),
                
                // 2x2 그리드의 감정 카드
                _buildMoodGrid(),
                
                const SizedBox(height: 40),
                
                // Quick Start 버튼
                GradientButton(
                  text: _getQuickStartText(),
                  onPressed: _onQuickStart,
                ),
                
                const SizedBox(height: 48),
                
                // 하단 네비게이션 바
                _buildBottomNav(isKo),
                
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// 헤더 위젯: "Still: Focus Timer"
  Widget _buildHeader() {
    return Row(
      children: [
        // 보라색 뇌 아이콘 (CustomPaint로 구현)
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: const Color(0xFF9C88FF).withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CustomPaint(
            painter: _BrainIconPainter(),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          'Still: Focus Timer',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
            fontFamily: 'Pretendard',
          ),
        ),
      ],
    );
  }

  /// 제목 위젯: "How are you feeling now?"
  Widget _buildTitle() {
    return Text(
      AppStrings.selectEmotion(context),
      style: TextStyle(
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: AppColors.textPrimary,
        fontFamily: 'Pretendard',
        height: 1.2,
      ),
    );
  }

  /// 감정 카드 그리드 (2x2)
  Widget _buildMoodGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: EmotionType.values.map((emotion) {
        return MoodCard(
          emotion: emotion,
          isSelected: _selectedEmotion == emotion,
          onTap: () => _onEmotionSelected(emotion),
        );
      }).toList(),
    );
  }

  /// 하단 네비게이션 바
  Widget _buildBottomNav(bool isKo) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_rounded,
            label: isKo ? '홈' : 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.bar_chart_rounded,
            label: isKo ? '통계' : 'Stats',
            isSelected: false,
            onTap: () => context.pushNamed('analytics'),
          ),
          _NavItem(
            icon: Icons.timer_rounded,
            label: isKo ? '포커스' : 'Focus',
            isSelected: false,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.person_rounded,
            label: isKo ? '프로필' : 'Profile',
            isSelected: false,
            onTap: () => context.pushNamed('settings'),
          ),
        ],
      ),
    );
  }
}

/// 뇌 아이콘 페인터 (보라색)
class _BrainIconPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF9C88FF)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    // 간단한 뇌 모양
    final path = Path();
    // 왼쪽 반구
    path.moveTo(size.width * 0.3, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.1,
      size.height * 0.4,
      size.width * 0.2,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.15,
      size.height * 0.75,
      size.width * 0.3,
      size.height * 0.7,
    );
    
    // 오른쪽 반구
    path.moveTo(size.width * 0.7, size.height * 0.3);
    path.quadraticBezierTo(
      size.width * 0.9,
      size.height * 0.4,
      size.width * 0.8,
      size.height * 0.6,
    );
    path.quadraticBezierTo(
      size.width * 0.85,
      size.height * 0.75,
      size.width * 0.7,
      size.height * 0.7,
    );
    
    // 중앙 연결
    path.moveTo(size.width * 0.3, size.height * 0.5);
    path.lineTo(size.width * 0.7, size.height * 0.5);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// 네비게이션 아이템
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 28,
            color: isSelected 
                ? const Color(0xFF9C88FF) 
                : AppColors.textMuted,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: isSelected 
                  ? const Color(0xFF9C88FF) 
                  : AppColors.textMuted,
              fontFamily: 'Pretendard',
            ),
          ),
        ],
      ),
    );
  }
}
