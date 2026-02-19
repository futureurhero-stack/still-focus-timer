import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../data/models/emotion_type.dart';
import '../../../data/repositories/task_repository.dart';
import '../../../data/models/task_model.dart';

/// 작업 입력 바텀 시트
class TaskInputSheet extends StatefulWidget {
  final EmotionType emotion;
  final int duration;
  final Function(String? taskDescription, int duration) onStart;

  const TaskInputSheet({
    super.key,
    required this.emotion,
    required this.duration,
    required this.onStart,
  });

  @override
  State<TaskInputSheet> createState() => _TaskInputSheetState();
}

class _TaskInputSheetState extends State<TaskInputSheet> {
  final _textController = TextEditingController();
  final _taskRepository = TaskRepository();
  List<TaskModel> _recentTasks = [];
  bool _isLoading = true;
  late int _selectedDuration;

  @override
  void initState() {
    super.initState();
    _selectedDuration = widget.duration;
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

  void _startSession() {
    final task = _textController.text.trim();
    widget.onStart(task.isEmpty ? null : task, _selectedDuration);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 헤더
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // 세션 정보
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: widget.emotion.color.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      widget.emotion.emoji,
                      style: const TextStyle(fontSize: 24),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        Localizations.localeOf(context).languageCode == 'ko'
                            ? '$_selectedDuration분 세션'
                            : '$_selectedDuration min session',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      Text(
                        widget.emotion.description(context),
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 세션 시간 조정 슬라이더
              Text(
                Localizations.localeOf(context).languageCode == 'ko'
                    ? '세션 시간 조정'
                    : 'Adjust session duration',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Text(
                    '5',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  Expanded(
                    child: Slider(
                      value: _selectedDuration.toDouble(),
                      min: 5,
                      max: 60,
                      divisions: 11,
                      label: '$_selectedDuration',
                      activeColor: widget.emotion.color,
                      onChanged: (value) {
                        setState(() {
                          _selectedDuration = value.round();
                        });
                      },
                    ),
                  ),
                  Text(
                    '60',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // 작업 입력 필드
              Text(
                AppStrings.taskInputTitle(context),
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _textController,
                autofocus: true,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16,
                ),
                decoration: InputDecoration(
                  hintText: AppStrings.taskInputHint(context),
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surfaceLight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 16,
                  ),
                ),
                onSubmitted: (_) => _startSession(),
              ),
              const SizedBox(height: 16),

              // 최근 작업 목록
              if (!_isLoading && _recentTasks.isNotEmpty) ...[
                Text(
                  AppStrings.recentTasks(context),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
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
                          color: AppColors.background,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: AppColors.surfaceLight,
                          ),
                        ),
                        child: Text(
                          task.description,
                          style: const TextStyle(
                            fontSize: 14,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
              ],

              // 시작 버튼
              SizedBox(
                width: double.infinity,
                  child: ElevatedButton(
                  onPressed: _startSession,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: widget.emotion.color,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    AppStrings.startTask(context),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
                  .animate()
                  .fadeIn(duration: AppDurations.animNormal)
                  .slideY(begin: 0.2, end: 0),
            ],
          ),
        ),
      ),
    );
  }
}

