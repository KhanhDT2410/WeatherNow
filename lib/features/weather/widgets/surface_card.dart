import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';

class SurfaceCard extends StatefulWidget {
  const SurfaceCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.large),
    this.borderRadius = AppRadius.medium,
    this.gradient,
    this.borderColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final double borderRadius;
  final List<Color>? gradient;
  final Color? borderColor;
  final VoidCallback? onTap;

  @override
  State<SurfaceCard> createState() => _SurfaceCardState();
}

class _SurfaceCardState extends State<SurfaceCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, _hovered ? -4 : 0, 0),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                widget.gradient ??
                [
                  Colors.white.withValues(alpha: 0.86),
                  Colors.white.withValues(alpha: 0.72),
                ],
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius),
          border: Border.all(
            color: widget.borderColor ?? AppColors.glassStroke,
          ),
          boxShadow: _hovered ? AppShadows.cardHover : AppShadows.card,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(widget.borderRadius),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.onTap,
            child: Padding(padding: widget.padding, child: widget.child),
          ),
        ),
      ),
    );
  }
}
