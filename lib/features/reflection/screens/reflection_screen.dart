import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/utils/date_utils.dart';
import '../../../data/repositories/session_repository.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/models/task_model.dart';
import '../../../shared/widgets/gradient_background.dart';

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
  final _taskRepository = TaskRepository();
  List<TaskModel> _recentTasks = [];
  bool _isLoading = true;
  bool _isSaving = false;

  bool _isKorean(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'ko';

  @override
  void initState() {
    super.initState();
    _loadRecentTasks();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _loadRecentTasks() async {
    final tasks = await _taskRepository.getRecentTasks(limit: 5);
    setState(() {
      _recentTasks = tasks;
      _isLoading = false;
    });
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
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 20),

                    // Header
                _buildHeader(),
                const SizedBox(height: 40),

                    // Result card
                _buildResultCard(),
                const SizedBox(height: 32),

                    // Reflection input
                _buildReflectionInput(),
                const SizedBox(height: 16),

                    // Recent task suggestions
                if (!_isLoading && _recentTasks.isNotEmpty)
                  _buildRecentTaskSuggestions(),

                const Spacer(),

                    // Buttons
                _buildButtons(),
                const SizedBox(height: 24),
              ],
            ),
          ),
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
              _isKorean(context)
                  ? (widget.isCompleted ? '🎉 완료!' : '💪 수고했어요')
                  : (widget.isCompleted ? '🎉 Great job!' : '💪 Nice effort'),
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              AppStrings.reflectionTitle(context),
              style: const TextStyle(
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal)
            .slideX(begin: -0.2, end: 0),

        // 건너뛰기 버튼
        TextButton(
          onPressed: _skip,
          child: Text(
            AppStrings.reflectionSkip(context),
            style: TextStyle(
              color: AppColors.textMuted,
              fontSize: 14,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 200.ms),
      ],
    );
  }

  Widget _buildResultCard() {
    final duration = Duration(seconds: widget.actualDuration);
    final formattedTime = AppDateUtils.formatDurationLong(duration);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: widget.isCompleted
              ? [
                  AppColors.success.withValues(alpha: 0.2),
                  AppColors.success.withValues(alpha: 0.1),
                ]
              : [
                  AppColors.warning.withValues(alpha: 0.2),
                  AppColors.warning.withValues(alpha: 0.1),
                ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: widget.isCompleted
              ? AppColors.success.withValues(alpha: 0.3)
              : AppColors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          // 결과 아이콘
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: widget.isCompleted
                  ? AppColors.success.withValues(alpha: 0.2)
                  : AppColors.warning.withValues(alpha: 0.2),
            ),
            child: Icon(
              widget.isCompleted
                  ? Icons.check_circle_outline
                  : Icons.timer_outlined,
              size: 32,
              color: widget.isCompleted
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
          const SizedBox(height: 16),

          // Focus time
          Text(
            formattedTime,
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: widget.isCompleted
                  ? AppColors.success
                  : AppColors.warning,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            _isKorean(context) ? '집중 시간' : 'Focus time',
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 100.ms)
        .scale(begin: const Offset(0.9, 0.9));
  }

  Widget _buildReflectionInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.reflectionQuestion(context),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        TextField(
          controller: _textController,
          maxLines: 3,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
          decoration: InputDecoration(
            hintText: AppStrings.reflectionHint(context),
            hintStyle: const TextStyle(color: AppColors.textMuted),
            filled: true,
            fillColor: AppColors.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(20),
          ),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 200.ms)
        .slideY(begin: 0.2, end: 0);
  }

  Widget _buildRecentTaskSuggestions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Did you work on any of these?',
          style: TextStyle(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _recentTasks.map((task) {
            return GestureDetector(
              onTap: () => _selectTask(task.description),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  task.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    )
        .animate()
        .fadeIn(duration: AppDurations.animNormal, delay: 300.ms);
  }

  Widget _buildButtons() {
    return Column(
      children: [
        // 저장 버튼
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isSaving ? null : _saveReflection,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              padding: const EdgeInsets.symmetric(vertical: 18),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
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
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 400.ms)
            .slideY(begin: 0.2, end: 0),

        const SizedBox(height: 12),

        // Back to home button
        TextButton(
          onPressed: _goHome,
          child: Text(
            Localizations.localeOf(context).languageCode == 'ko'
                ? '홈으로 돌아가기'
                : 'Back to Home',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        )
            .animate()
            .fadeIn(duration: AppDurations.animNormal, delay: 500.ms),
      ],
    );
  }
}

