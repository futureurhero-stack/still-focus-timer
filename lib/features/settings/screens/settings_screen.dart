import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_assets.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../shared/widgets/gradient_background.dart';
import '../../../shared/widgets/svg_icon.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../core/providers/default_duration_provider.dart';
import '../../../data/local/database_service.dart';

/// 설정 화면
class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final _db = DatabaseService();
  int _defaultDuration = 10;
  bool _notificationsEnabled = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final duration = await _db.getSetting<int>('defaultDuration');
    final notifications = await _db.getSetting<bool>('notificationsEnabled');
    
    setState(() {
      _defaultDuration = duration ?? 10;
      _notificationsEnabled = notifications ?? true;
    });
  }

  Future<void> _saveDuration(int duration) async {
    await ref.read(defaultDurationProvider.notifier).updateDuration(duration);
    setState(() => _defaultDuration = duration);
  }

  Future<void> _toggleNotifications(bool value) async {
    await _db.setSetting('notificationsEnabled', value);
    setState(() => _notificationsEnabled = value);
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text(
          'Delete all data',
          style: TextStyle(color: AppColors.textPrimary),
        ),
        content: const Text(
          'All session history and settings will be deleted.\nThis action cannot be undone.',
          style: TextStyle(color: AppColors.textSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await _db.clearAll();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('All data has been deleted.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // AppBar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => context.pop(),
                      icon: SvgIcon(
                        assetPath: AppAssets.iconClose,
                        size: 40,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Expanded(
                      child: Text(
                        AppStrings.settingsTitle(context),
                        style: const TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final isCompact = constraints.maxWidth < 380;
                    return ListView(
                      padding: EdgeInsets.all(isCompact ? 20 : 28),
                  children: [
                    // 언어 설정
                    _buildLanguageSection()
                        .animate()
                        .fadeIn(duration: AppDurations.animNormal)
                        .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 48),

                    // Focus session defaults
                    _buildSection(
                      title: 'Session settings',
                      children: [
                        _buildDurationSetting(),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: AppDurations.animNormal)
                    .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 48),

                    // Notification settings
                    _buildSection(
                      title: 'Notifications',
                      children: [
                        _buildSwitchTile(
                          iconPath: AppAssets.iconNotification,
                          title: 'Enable notifications',
                          subtitle: 'Get notified when a session ends',
                          value: _notificationsEnabled,
                          onChanged: _toggleNotifications,
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: AppDurations.animNormal, delay: 100.ms)
                    .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 48),

                    // App info
                    _buildSection(
                      title: 'About',
                      children: [
                        _buildInfoTile(
                          iconPath: AppAssets.iconStar,
                          title: 'Version',
                          value: '2.0.0',
                        ),
                        _buildInfoTile(
                          iconPath: AppAssets.iconCrown,
                          title: 'Developer',
                          value: 'FocusFlow Team',
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: AppDurations.animNormal, delay: 200.ms)
                    .slideY(begin: 0.1, end: 0),

                    const SizedBox(height: 48),

                    // Data management
                    _buildSection(
                      title: 'Data management',
                      children: [
                        _buildActionTile(
                          iconPath: AppAssets.iconReset,
                          title: 'Delete all data',
                          subtitle: 'Remove all session history and settings',
                          isDestructive: true,
                          onTap: _clearAllData,
                        ),
                      ],
                    )
                    .animate()
                    .fadeIn(duration: AppDurations.animNormal, delay: 300.ms)
                    .slideY(begin: 0.1, end: 0),
                  ],
                );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Language section (English / Korean 슬라이드 스타일)
  Widget _buildLanguageSection() {
    return Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(localeProvider);
        final isKorean = locale.languageCode == 'ko';

        return _buildSection(
          title: AppStrings.settingsLanguage(context),
          children: [
            Padding(
              padding: const EdgeInsets.all(20),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceLight,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceLight, width: 1),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(localeProvider.notifier).setEnglish(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: !isKorean ? AppColors.accent : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: !isKorean
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            'English',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: !isKorean ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => ref.read(localeProvider.notifier).setKorean(),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          decoration: BoxDecoration(
                            color: isKorean ? AppColors.accent : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: isKorean
                                ? [
                                    BoxShadow(
                                      color: AppColors.accent.withValues(alpha: 0.3),
                                      blurRadius: 8,
                                      offset: const Offset(0, 2),
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            '한국어',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: isKorean ? Colors.white : AppColors.textSecondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildSection({
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 24),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(32),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSetting() {
    final isCompact = MediaQuery.of(context).size.width < 380;
    final padding = isCompact ? 20.0 : 28.0;
    final titleSize = isCompact ? 24.0 : 28.0;
    final subtitleSize = isCompact ? 18.0 : 22.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(isCompact ? 12 : 16),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: SvgIcon(
                  assetPath: AppAssets.iconFocus,
                  size: isCompact ? 28 : 36,
                  color: AppColors.accent,
                ),
              ),
              SizedBox(width: isCompact ? 16 : 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.defaultDuration(context),
                      style: TextStyle(
                        fontSize: titleSize,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      AppStrings.defaultSessionSubtitle(context),
                      style: TextStyle(
                        fontSize: subtitleSize,
                        color: AppColors.textSecondary,
                        fontWeight: FontWeight.w400,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '$_defaultDuration min',
                style: TextStyle(
                  fontSize: isCompact ? 24 : 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          // 슬라이더
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.accent,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: AppColors.accent,
              overlayColor: AppColors.accent.withValues(alpha: 0.2),
              trackHeight: 6,
            ),
            child: Slider(
              value: _defaultDuration.toDouble(),
              min: 5,
              max: 60,
              divisions: 11,
              onChanged: (value) {
                setState(() => _defaultDuration = value.toInt());
              },
              onChangeEnd: (value) {
                _saveDuration(value.toInt());
              },
            ),
          ),
          // 시간 옵션
          Wrap(
            spacing: isCompact ? 8 : 12,
            runSpacing: 8,
            children: [5, 10, 15, 25, 40, 60].map((duration) {
              final isSelected = _defaultDuration == duration;
              return GestureDetector(
                onTap: () => _saveDuration(duration),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isCompact ? 10 : 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.accent.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.surfaceLight,
                    ),
                  ),
                  child: Text(
                    '$duration',
                    style: TextStyle(
                      fontSize: isCompact ? 18 : 22,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppColors.accent
                          : AppColors.textMuted,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSwitchTile({
    required String iconPath,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isCompact = MediaQuery.of(context).size.width < 380;
    final padding = isCompact ? 20.0 : 28.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isCompact ? 8 : 10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgIcon(
              assetPath: iconPath,
              size: isCompact ? 28 : 36,
              color: AppColors.accent,
            ),
          ),
          SizedBox(width: isCompact ? 12 : 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: isCompact ? 18 : 20,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isCompact ? 16 : 18,
                    color: AppColors.textMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: AppColors.accent.withValues(alpha: 0.5),
            activeThumbColor: AppColors.accent,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required String iconPath,
    required String title,
    required String value,
  }) {
    final isCompact = MediaQuery.of(context).size.width < 380;
    final padding = isCompact ? 20.0 : 28.0;

    return Padding(
      padding: EdgeInsets.all(padding),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(isCompact ? 8 : 10),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: SvgIcon(
              assetPath: iconPath,
              size: isCompact ? 28 : 36,
              color: AppColors.accent,
            ),
          ),
          SizedBox(width: isCompact ? 12 : 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontSize: isCompact ? 18 : 20,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: TextStyle(
                fontSize: isCompact ? 20 : 24,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary,
              ),
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.end,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required String iconPath,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;
    final isCompact = MediaQuery.of(context).size.width < 380;
    final padding = isCompact ? 20.0 : 28.0;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isCompact ? 8 : 10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: SvgIcon(
                assetPath: iconPath,
                size: isCompact ? 28 : 36,
                color: color,
              ),
            ),
            SizedBox(width: isCompact ? 12 : 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: isCompact ? 18 : 20,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: isCompact ? 16 : 18,
                      color: AppColors.textMuted,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: AppColors.textMuted,
            ),
          ],
        ),
      ),
    );
  }
}

