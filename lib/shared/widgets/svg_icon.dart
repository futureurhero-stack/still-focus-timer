import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// SVG 아이콘 위젯
class SvgIcon extends StatelessWidget {
  final String assetPath;
  final double size;
  final Color? color;
  final BoxFit fit;

  const SvgIcon({
    super.key,
    required this.assetPath,
    this.size = 24,
    this.color,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: SvgPicture.asset(
        assetPath,
        width: size,
        height: size,
        fit: fit,
        colorFilter: color != null
            ? ColorFilter.mode(color!, BlendMode.srcIn)
            : null,
      ),
    );
  }
}




