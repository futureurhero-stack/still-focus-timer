import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/svg_icon.dart';

/// 통계 카드 위젯
class StatsCard extends StatelessWidget {
  final IconData? icon;
  final String? iconPath;
  final String label;
  final String value;
  final Color color;

  const StatsCard({
    super.key,
    this.icon,
    this.iconPath,
    required this.label,
    required this.value,
    required this.color,
  }) : assert(icon != null || iconPath != null, 'icon or iconPath required');

  @override
  Widget build(BuildContext context) {
    const baseText = Color(0xFF121318);
    final glowA = color.withValues(alpha: 0.12);
    final glowB = color.withValues(alpha: 0.06);

    return Container(
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
              left: -20,
              top: -20,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: glowA,
                ),
              ),
            ),

            // Bottom accent bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Container(
                height: 3,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(99),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      color.withValues(alpha: 0.7),
                      color.withValues(alpha: 0.1),
                    ],
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                    ),
                    child: iconPath != null
                        ? SvgIcon(
                            assetPath: iconPath!,
                            size: 24,
                            color: color,
                          )
                        : Icon(
                            icon!,
                            color: color,
                            size: 24,
                          ),
                  ),
                  const SizedBox(height: 20),

                  // Label
                  Text(
                    label.toUpperCase(),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w900,
                      color: baseText.withValues(alpha: 0.5),
                      letterSpacing: 1.2,
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Value
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: color,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 8), // For bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

