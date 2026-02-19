import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/providers/default_duration_provider.dart';
import '../../../data/models/emotion_type.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/custom_button.dart';
import '../widgets/emotion_selector.dart';
import '../widgets/task_input_sheet.dart';

/// Home screen
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  EmotionType? _selectedEmotion;
  int _currentDuration = 10; // 현재 선택된 세션 시간

  bool _isKorean(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ko';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateDurationFromProvider();
    });
  }

  void _updateDurationFromProvider() {
    final defaultDuration = ref.read(defaultDurationProvider);
    if (mounted) {
      setState(() {
        // 감정이 선택되지 않았거나 '괜찮음'인 경우에만 기본 시간 업데이트
        if (_selectedEmotion == null || _selectedEmotion == EmotionType.good) {
          _currentDuration = defaultDuration;
        }
      });
    }
  }

  /// 감정에 따른 세션 시간 계산
  int _getDurationForEmotion(EmotionType? emotion) {
    final defaultDuration = ref.read(defaultDurationProvider);
    if (emotion == null) {
      return defaultDuration;
    }
    switch (emotion) {
      case EmotionType.tired:
        return 5; // 하기 싫음: 5분
      case EmotionType.stressed:
        return 10; // 스트레스: 10분
      case EmotionType.sleepy:
        return 15; // 졸림: 15분
      case EmotionType.good:
        return defaultDuration; // 괜찮음: 설정의 기본 세션 시간
    }
  }

  void _showTaskInput() {
    final defaultDuration = ref.read(defaultDurationProvider);
    
    if (_selectedEmotion == null) {
      // If no emotion is selected, use default
      setState(() {
        _selectedEmotion = EmotionType.good;
        _currentDuration = defaultDuration;
      });
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => TaskInputSheet(
        emotion: _selectedEmotion!,
        duration: _currentDuration, // 현재 선택된 세션 시간 사용
        onStart: (taskDescription, duration) {
          _startSession(taskDescription, duration);
        },
      ),
    );
  }

  void _startSession(String? taskDescription, int duration) {
    context.pushNamed(
      'timer',
      extra: {
        'emotion': _selectedEmotion ?? EmotionType.good,
        'duration': duration,
        'task': taskDescription,
      },
    );
  }

  void _quickStart() {
    // Quick start: begin without selecting emotion
    final emotion = _selectedEmotion ?? EmotionType.good;
    // 감정에 따른 세션 시간 계산
    final duration = _getDurationForEmotion(emotion);
    
    context.pushNamed(
      'timer',
      extra: {
        'emotion': emotion,
        'duration': duration, // 감정에 따른 세션 시간 사용
        'task': null,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Stack(
          children: [
            // Background decoration
            const Positioned(
              top: -100,
              right: -100,
              child: BackgroundOrb(
                color: AppColors.primary,
                size: 300,
                alignment: Alignment.topRight,
              ),
            ),
            const Positioned(
              bottom: -50,
              left: -50,
              child: BackgroundOrb(
                color: AppColors.secondary,
                size: 200,
                alignment: Alignment.bottomLeft,
              ),
            ),

            // Main content
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 20),

                    // Header
                    _buildHeader(),
                    const SizedBox(height: 40),

                    // Welcome message
                    _buildWelcomeMessage(),
                    const SizedBox(height: 32),

                    // Emotion selector
                    EmotionSelector(
                      selectedEmotion: _selectedEmotion,
                      onEmotionSelected: (emotion) {
                        setState(() {
                          _selectedEmotion = emotion;
                          // 감정 선택 시 해당 감정의 권장 시간으로 업데이트
                          _currentDuration = _getDurationForEmotion(emotion);
                        });
                      },
                    ),
                    const SizedBox(height: 24),

                    // Selected emotion info
                    if (_selectedEmotion != null)
                      EmotionInfoCard(emotion: _selectedEmotion!),

                    const Spacer(),

                    // Start button
                    _buildStartButton(),
                    const SizedBox(height: 16),

                    // Quick start button
                    _buildQuickStartButton(),
                    const SizedBox(height: 24),

                    // Bottom navigation
                    _buildBottomNav(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppStrings.appName(context),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            Text(
              AppStrings.appTagline(context),
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal)
            .slideX(begin: -0.2, end: 0),
        // Settings button
        IconButton(
          onPressed: () => context.pushNamed('settings'),
          icon: const Icon(
            Icons.settings_outlined,
            color: AppColors.textSecondary,
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 200.ms)
            .scale(begin: const Offset(0.8, 0.8)),
      ],
    );
  }

  Widget _buildWelcomeMessage() {
    final hour = DateTime.now().hour;
    final isKo = _isKorean(context);
    String greeting;
    if (hour < 12) {
      greeting = isKo ? '좋은 아침이에요!' : 'Good morning!';
    } else if (hour < 18) {
      greeting = isKo ? '좋은 오후예요!' : 'Good afternoon!';
    } else {
      greeting = isKo ? '좋은 저녁이에요!' : 'Good evening!';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          greeting,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          AppStrings.welcomeMessage(context),
          style: const TextStyle(
            fontSize: 16,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 100.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildStartButton() {
    final defaultDuration = ref.watch(defaultDurationProvider);
    final hasEmotion = _selectedEmotion != null;
    // 감정이 선택된 경우 현재 세션 시간 사용, 아니면 기본 시간 사용
    final duration = hasEmotion ? _currentDuration : defaultDuration;
    final buttonText = hasEmotion
        ? (_isKorean(context)
            ? '$duration분 시작하기'
            : 'Start $duration minutes')
        : AppStrings.startButton(context);

    return StartButton(
      text: buttonText,
      onPressed: _showTaskInput,
      isEnabled: true,
    );
  }

  Widget _buildQuickStartButton() {
    return TextButton(
      onPressed: _quickStart,
      child: Text(
        Localizations.localeOf(context).languageCode == 'ko'
            ? '작업 입력 없이 바로 시작 →'
            : 'Start without entering a task →',
        style: const TextStyle(
          color: AppColors.textSecondary,
          fontSize: 14,
        ),
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 300.ms);
  }

  Widget _buildBottomNav() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _NavButton(
          icon: Icons.home_rounded,
          label:
              Localizations.localeOf(context).languageCode == 'ko' ? '홈' : 'Home',
          isSelected: true,
          onTap: () {},
        ),
        const SizedBox(width: 32),
        _NavButton(
          icon: Icons.bar_chart_rounded,
          label:
              Localizations.localeOf(context).languageCode == 'ko' ? '통계' : 'Analytics',
          isSelected: false,
          onTap: () => context.pushNamed('analytics'),
        ),
        const SizedBox(width: 32),
        _NavButton(
          icon: Icons.settings_rounded,
          label:
              Localizations.localeOf(context).languageCode == 'ko' ? '설정' : 'Settings',
          isSelected: false,
          onTap: () => context.pushNamed('settings'),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 400.ms);
  }
}

/// 하단 네비게이션 버튼
class _NavButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _NavButton({
    required this.icon,
    required this.label,
    required this.isSelected,
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
            color: isSelected ? AppColors.primary : AppColors.textMuted,
            size: 28,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}




