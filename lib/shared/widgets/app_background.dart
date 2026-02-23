import 'package:flutter/material.dart';
import '../../core/constants/app_assets.dart';

/// 시간대별 배경 이미지 + 장식 오버레이
class AppBackground extends StatelessWidget {
  final Widget child;
  final bool showDecoration;

  const AppBackground({
    super.key,
    required this.child,
    this.showDecoration = true,
  });

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final bgPath = AppAssets.getBackgroundForHour(hour);

    return Stack(
      fit: StackFit.expand,
      children: [
        // 배경 이미지 (터치 통과 - 클릭 방해 안 함)
        IgnorePointer(
          child: Image.asset(
            bgPath,
            fit: BoxFit.cover,
          ),
        ),
        // 노이즈 텍스처 오버레이 (미묘한 질감)
        if (showDecoration)
          IgnorePointer(
            child: Opacity(
              opacity: 0.03,
              child: Image.asset(
                AppAssets.decoNoiseTexture,
                fit: BoxFit.cover,
              ),
            ),
          ),
        // 콘텐츠 (터치 가능)
        child,
      ],
    );
  }
}

