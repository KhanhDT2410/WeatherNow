import 'dart:async';

import 'package:flutter/material.dart';

class MotionReveal extends StatefulWidget {
  const MotionReveal({
    super.key,
    required this.child,
    this.delay = Duration.zero,
  });

  final Widget child;
  final Duration delay;

  @override
  State<MotionReveal> createState() => _MotionRevealState();
}

class _MotionRevealState extends State<MotionReveal> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    unawaited(_animateIn());
  }

  Future<void> _animateIn() async {
    if (widget.delay > Duration.zero) {
      await Future<void>.delayed(widget.delay);
    }

    if (!mounted) {
      return;
    }

    setState(() {
      _visible = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      opacity: _visible ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
        offset: _visible ? Offset.zero : const Offset(0, 0.08),
        child: widget.child,
      ),
    );
  }
}
