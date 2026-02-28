import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/providers/default_duration_provider.dart';
import '../../../data/models/emotion_type.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/gradient_button.dart';

/// Home screen - Premium & Sophisticated Design
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  EmotionType? _selectedEmotion;

  /// Get mapping of EmotionType to Premium Display Data
  _EmotionDisplayData _getEmotionData(EmotionType type) {
    switch (type) {
      case EmotionType.stressed:
        return const _EmotionDisplayData(
          label: 'Overwhelmed',
          subtitle: 'Calm the chaos',
          duration: '10 min',
          color: Color(0xFFFEE2E2),
          iconColor: Color(0xFFEF4444),
        );
      case EmotionType.tired:
        return const _EmotionDisplayData(
          label: 'Distracted',
          subtitle: 'Find your focus',
          duration: '5 min',
          color: Color(0xFFDBEAFE),
          iconColor: Color(0xFF3B82F6),
        );
      case EmotionType.sleepy:
        return const _EmotionDisplayData(
          label: 'Low Energy',
          subtitle: 'Gentle recharge',
          duration: '15 min',
          color: Color(0xFFD1FAE5),
          iconColor: Color(0xFF10B981),
        );
      case EmotionType.good:
        return const _EmotionDisplayData(
          label: 'In the Zone',
          subtitle: 'Maximum flow',
          duration: '25 min',
          color: Color(0xFFEDE9FE),
          iconColor: Color(0xFF8B5CF6),
        );
    }
  }

  String _getQuickStartText() {
    final defaultDuration = ref.read(defaultDurationProvider);
    return '${AppStrings.quickStart(context)} $defaultDuration${AppStrings.minutes(context)}';
  }

  void _onEmotionSelected(EmotionType emotion) {
    setState(() {
      _selectedEmotion = _selectedEmotion == emotion ? null : emotion;
    });
  }

  void _onQuickStart() {
    final duration = _selectedEmotion?.recommendedDuration ??
        ref.read(defaultDurationProvider);
    final emotion = _selectedEmotion ?? EmotionType.good;

    context.pushNamed('timer', extra: {
      'emotion': emotion,
      'duration': duration,
      'task': 'quick_start',
    });
  }

  @override
  Widget build(BuildContext context) {
    final isKo = Localizations.localeOf(context).languageCode == 'ko';
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          // Elegant subtle gradient background
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    const Color(0xFFFDFCFB),
                    const Color(0xFFF5F2EF).withValues(alpha:0.5),
                  ],
                ),
              ),
            ),
          ),
          
          SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        _buildHeader(),
                        const SizedBox(height: 40),
                        _buildTitle(),
                        const SizedBox(height: 32),
                        _buildMoodGrid(),
                        const SizedBox(height: 40),
                        _buildQuickStartButton(),
                        const SizedBox(height: 48),
                      ],
                    ),
                  ),
                ),
                _buildBottomNav(isKo),
              ],
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
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha:0.04),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const Icon(
                Icons.blur_on_rounded,
                color: Color(0xFF8B5CF6),
                size: 24,
              ),
            ),
            const SizedBox(width: 12),
            const Text(
              'Still',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: -0.5,
                color: Color(0xFF1F2937),
              ),
            ),
          ],
        ),
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.black.withValues(alpha:0.05)),
          ),
          child: const Icon(Icons.notifications_none_rounded, size: 20, color: Color(0xFF6B7280)),
        ),
      ],
    );
  }

  Widget _buildTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'How are you feeling?',
          style: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111827),
            letterSpacing: -1,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select a mode to match your current state.',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF111827).withValues(alpha:0.5),
          ),
        ),
      ],
    );
  }

  Widget _buildMoodGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: EmotionType.values.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 20,
        crossAxisSpacing: 20,
        childAspectRatio: 0.88,
      ),
      itemBuilder: (context, index) {
        final emotion = EmotionType.values[index];
        final data = _getEmotionData(emotion);
        final isSelected = _selectedEmotion == emotion;

        return _PremiumMoodCard(
          data: data,
          isSelected: isSelected,
          onTap: () => _onEmotionSelected(emotion),
          icon: _getEmotionIcon(emotion, data.iconColor),
        );
      },
    );
  }

  Widget _buildQuickStartButton() {
    return SizedBox(
      width: double.infinity,
      height: 64,
      child: GradientButton(
        text: _getQuickStartText(),
        onPressed: _onQuickStart,
      ),
    );
  }

  Widget _buildBottomNav(bool isKo) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF111827).withValues(alpha:0.2),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home_filled,
            label: isKo ? '홈' : 'Home',
            isSelected: true,
            onTap: () {},
          ),
          _NavItem(
            icon: Icons.analytics_outlined,
            label: isKo ? '통계' : 'Stats',
            isSelected: false,
            onTap: () => context.pushNamed('analytics'),
          ),
          _NavItem(
            icon: Icons.timer_outlined,
            label: isKo ? '타이머' : 'Timer',
            isSelected: false,
            onTap: () {}, // Handled by cards/quickstart
          ),
          _NavItem(
            icon: Icons.settings_outlined,
            label: isKo ? '설정' : 'Settings',
            isSelected: false,
            onTap: () => context.pushNamed('settings'),
          ),
        ],
      ),
    );
  }

  Widget _getEmotionIcon(EmotionType emotion, Color color) {
    switch (emotion) {
      case EmotionType.stressed:
        return Icon(Icons.water_drop_outlined, color: color, size: 32);
      case EmotionType.tired:
        return Icon(Icons.grain_rounded, color: color, size: 32);
      case EmotionType.sleepy:
        return Icon(Icons.nights_stay_outlined, color: color, size: 32);
      case EmotionType.good:
        return Icon(Icons.auto_awesome_outlined, color: color, size: 32);
    }
  }
}

class _EmotionDisplayData {
  final String label;
  final String subtitle;
  final String duration;
  final Color color;
  final Color iconColor;

  const _EmotionDisplayData({
    required this.label,
    required this.subtitle,
    required this.duration,
    required this.color,
    required this.iconColor,
  });
}

class _PremiumMoodCard extends StatefulWidget {
  final _EmotionDisplayData data;
  final bool isSelected;
  final VoidCallback onTap;
  final Widget icon;

  const _PremiumMoodCard({
    required this.data,
    required this.isSelected,
    required this.onTap,
    required this.icon,
  });

  @override
  State<_PremiumMoodCard> createState() => _PremiumMoodCardState();
}

class _PremiumMoodCardState extends State<_PremiumMoodCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) {
        HapticFeedback.lightImpact();
        setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () {
        setState(() => _isPressed = false);
      },
      child: AnimatedScale(
        scale: _isPressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: widget.isSelected ? widget.data.iconColor.withValues(alpha:0.5) : Colors.transparent,
              width: 2,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha:_isPressed 
                    ? 0.02 
                    : (widget.isSelected ? 0.08 : 0.04)),
                blurRadius: _isPressed ? 10 : (widget.isSelected ? 30 : 20),
                offset: Offset(0, _isPressed ? 5 : (widget.isSelected ? 15 : 10)),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  widget.icon,
                  Text(
                    widget.data.duration,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF111827).withValues(alpha:0.4),
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                widget.data.label,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF111827),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                widget.data.subtitle,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF111827).withValues(alpha:0.4),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? Colors.white.withValues(alpha:0.1) : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              icon,
              size: 24,
              color: isSelected ? Colors.white : Colors.white.withValues(alpha:0.4),
            ),
          ),
        ],
      ),
    );
  }
}
