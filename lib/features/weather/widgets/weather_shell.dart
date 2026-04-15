import 'dart:ui';

import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';

class WeatherShell extends StatelessWidget {
  const WeatherShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Positioned.fill(
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [AppColors.pageTop, AppColors.pageBottom],
              ),
            ),
          ),
        ),
        const _GlowOrb(
          alignment: Alignment.topLeft,
          size: 320,
          color: AppColors.pageGlow,
          offset: Offset(-90, -80),
        ),
        const _GlowOrb(
          alignment: Alignment.topRight,
          size: 260,
          color: AppColors.pageGlowSecondary,
          offset: Offset(120, -20),
        ),
        const _GlowOrb(
          alignment: Alignment.bottomLeft,
          size: 300,
          color: AppColors.primaryDeep,
          offset: Offset(-110, 120),
        ),
        SafeArea(
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                maxWidth: AppBreakpoints.maxContentWidth,
              ),
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.medium),
                child: child,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({
    required this.alignment,
    required this.size,
    required this.color,
    required this.offset,
  });

  final Alignment alignment;
  final double size;
  final Color color;
  final Offset offset;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: Transform.translate(
        offset: offset,
        child: IgnorePointer(
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(sigmaX: 70, sigmaY: 70),
            child: Container(
              height: size,
              width: size,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withValues(alpha: 0.22),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
