import 'package:flutter/material.dart';

/// Simple global background wrapper used by multiple screens.
/// Matches the soft wave / pale gradient used in the new Home & Reflection UIs.
class GradientBackground extends StatelessWidget {
  final Widget child;

  const GradientBackground({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: child,
    );
  }
}

