import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_durations.dart';
import '../../../core/locale/locale_provider.dart';
import '../../../data/local/database_service.dart';

/// 설정 화면
class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
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
    await _db.setSetting('defaultDuration', duration);
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
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          onPressed: () => context.pop(),
          icon: const Icon(Icons.arrow_back_ios),
        ),
        title: Text(AppStrings.settingsTitle(context)),
      ),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          // 언어 설정
          _buildLanguageSection()
              .animate()
              .fadeIn(duration: AppDurations.animNormal)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 24),

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

          const SizedBox(height: 24),

          // Notification settings
          _buildSection(
            title: 'Notifications',
            children: [
              _buildSwitchTile(
                icon: Icons.notifications_outlined,
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

          const SizedBox(height: 24),

          // App info
          _buildSection(
            title: 'About',
            children: [
              _buildInfoTile(
                icon: Icons.info_outline,
                title: 'Version',
                value: '1.0.0',
              ),
              _buildInfoTile(
                icon: Icons.code,
                title: 'Developer',
                value: 'FocusFlow Team',
              ),
            ],
          )
              .animate()
              .fadeIn(duration: AppDurations.animNormal, delay: 200.ms)
              .slideY(begin: 0.1, end: 0),

          const SizedBox(height: 24),

          // Data management
          _buildSection(
            title: 'Data management',
            children: [
              _buildActionTile(
                icon: Icons.delete_outline,
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
      ),
    );
  }

  /// Language section (English / Korean switch)
  Widget _buildLanguageSection() {
    return Consumer(
      builder: (context, ref, _) {
        final locale = ref.watch(localeProvider);
        final currentLanguage = locale.languageCode;

        return _buildSection(
          title: 'Language',
          children: [
            ListTile(
              title: const Text('English'),
              trailing: currentLanguage == 'en'
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.textMuted,
                    ),
              onTap: () {
                ref.read(localeProvider.notifier).setEnglish();
              },
            ),
            const Divider(height: 1),
            ListTile(
              title: const Text('Korean'),
              trailing: currentLanguage == 'ko'
                  ? const Icon(
                      Icons.check_circle,
                      color: AppColors.primary,
                    )
                  : const Icon(
                      Icons.radio_button_unchecked,
                      color: AppColors.textMuted,
                    ),
              onTap: () {
                ref.read(localeProvider.notifier).setKorean();
              },
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
          padding: const EdgeInsets.only(left: 4, bottom: 12),
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: children,
          ),
        ),
      ],
    );
  }

  Widget _buildDurationSetting() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.timer_outlined,
                  color: AppColors.primary,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.defaultDuration(context),
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      Localizations.localeOf(context).languageCode == 'ko'
                          ? '기본 집중 세션 시간'
                          : 'Default focus session length',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$_defaultDuration min',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // 슬라이더
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: AppColors.primary,
              inactiveTrackColor: AppColors.surfaceLight,
              thumbColor: AppColors.primary,
              overlayColor: AppColors.primary.withValues(alpha: 0.2),
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [5, 10, 15, 25, 40, 60].map((duration) {
              final isSelected = _defaultDuration == duration;
              return GestureDetector(
                onTap: () => _saveDuration(duration),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? AppColors.primary.withValues(alpha: 0.2)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceLight,
                    ),
                  ),
                  child: Text(
                    '$duration',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isSelected
                          ? AppColors.primary
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
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.info,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: AppColors.primary,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: AppColors.secondary,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool isDestructive = false,
  }) {
    final color = isDestructive ? AppColors.error : AppColors.textPrimary;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: color,
                size: 20,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textMuted,
                    ),
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

