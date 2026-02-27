import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

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
  String _version = '—';

  @override
  void initState() {
    super.initState();
    _loadSettings();
    _loadVersion();
  }

  Future<void> _loadVersion() async {
    final info = await PackageInfo.fromPlatform();
    if (mounted) {
      setState(() {
        _version = info.version;
        if (info.buildNumber.isNotEmpty) {
          _version = '${info.version}+${info.buildNumber}';
        }
      });
    }
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
      backgroundColor: const Color(0xFFF7F8FC),
      body: Stack(
        children: [
          // 1) Soft wave background
          const _SoftWaveBackground(),
          // 2) Content
          SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: IconButton(
                          // Settings는 하단 탭에서 진입하므로 pop() 대신 홈으로 명시적으로 이동
                          onPressed: () => context.go('/'),
                          icon: const Icon(
                            Icons.arrow_back_rounded,
                            color: Color(0xFF121318),
                            size: 24,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'PREFERENCES',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w900,
                                color: AppColors.accent,
                                letterSpacing: 2,
                              ),
                            ),
                            Text(
                              AppStrings.settingsTitle(context),
                              style: const TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.w900,
                                color: Color(0xFF121318),
                                letterSpacing: -1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isCompact = constraints.maxWidth < 380;
                      return ListView(
                        padding: EdgeInsets.all(isCompact ? 20 : 28),
                        children: [
                          // Language 설정
                          _buildLanguageSection()
                              .animate()
                              .fadeIn(duration: 400.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 32),
                          // Focus session defaults
                          _buildSection(
                            title: AppStrings.sessionSettings(context),
                            children: [
                              _buildDurationSetting(),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 100.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 32),
                          // Notification settings
                          _buildSection(
                            title: AppStrings.notifications(context),
                            children: [
                              _buildSwitchTile(
                                icon: Icons.notifications_active_rounded,
                                title: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '알림 허용'
                                    : 'Enable notifications',
                                subtitle: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '세션 종료 알림'
                                    : 'Get notified when a session ends',
                                value: _notificationsEnabled,
                                onChanged: _toggleNotifications,
                                color: const Color(0xFF3C6FF2),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 200.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 32),
                          // App info
                          _buildSection(
                            title: AppStrings.about(context),
                            children: [
                              _buildInfoTile(
                                icon: Icons.info_outline_rounded,
                                title: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '버전'
                                    : 'Version',
                                value: _version,
                                color: const Color(0xFF6E5CF6),
                              ),
                              _buildInfoTile(
                                icon: Icons.code_rounded,
                                title: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '개발자'
                                    : 'Developer',
                                value: 'Still — Focus Timer',
                                color: const Color(0xFF10B981),
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 300.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 32),
                          // Data management
                          _buildSection(
                            title: AppStrings.dataManagement(context),
                            children: [
                              _buildActionTile(
                                icon: Icons.delete_forever_rounded,
                                title: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '데이터 전부 삭제'
                                    : 'Delete all data',
                                subtitle: Localizations.localeOf(context).languageCode == 'ko'
                                    ? '모든 기록과 설정 지우기'
                                    : 'Remove all history and settings',
                                isDestructive: true,
                                onTap: _clearAllData,
                              ),
                            ],
                          )
                              .animate()
                              .fadeIn(duration: 400.ms, delay: 400.ms)
                              .slideY(begin: 0.1, end: 0),
                          const SizedBox(height: 48),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
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
    const glowB = Color(0xFFE87D54); // AppColors.accent equivalent glow
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 12),
          child: Text(
            title.toUpperCase(),
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
            borderRadius: BorderRadius.circular(28),
            border: Border.all(color: const Color(0xFF121318).withValues(alpha: 0.08), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.055),
                blurRadius: 30,
                offset: const Offset(0, 18),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(28),
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
                  children: children,
                ),
              ],
            ),
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  size: 24,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStrings.defaultDuration(context),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF121318),
                      ),
                    ),
                    Text(
                      AppStrings.defaultSessionSubtitle(context),
                      style: TextStyle(
                        fontSize: 13,
                        color: const Color(0xFF121318).withValues(alpha: 0.4),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                '$_defaultDuration',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w900,
                  color: AppColors.accent,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                'min',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent.withValues(alpha: 0.5),
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
          const SizedBox(height: 16),
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
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF121318),
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 13,
                    color: const Color(0xFF121318).withValues(alpha: 0.4),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeTrackColor: color.withValues(alpha: 0.4),
            activeThumbColor: color,
            padding: EdgeInsets.zero,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              size: 24,
              color: color,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF121318),
              ),
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF121318).withValues(alpha: 0.5),
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
      borderRadius: BorderRadius.circular(28),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 24,
                color: color,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 13,
                      color: const Color(0xFF121318).withValues(alpha: 0.4),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right_rounded,
              color: const Color(0xFF121318).withValues(alpha: 0.25),
            ),
          ],
        ),
      ),
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

