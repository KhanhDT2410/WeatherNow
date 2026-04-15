import 'package:flutter/material.dart';

class LoadingRefreshButton extends StatefulWidget {
  const LoadingRefreshButton({
    super.key,
    required this.isLoading,
    required this.onPressed,
  });

  final bool isLoading;
  final VoidCallback onPressed;

  @override
  State<LoadingRefreshButton> createState() => _LoadingRefreshButtonState();
}

class _LoadingRefreshButtonState extends State<LoadingRefreshButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant LoadingRefreshButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.isLoading && _controller.isAnimating) {
      _controller.stop();
      _controller.reset();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
        side: BorderSide(color: Colors.white.withValues(alpha: 0.18)),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: widget.isLoading ? null : widget.onPressed,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              RotationTransition(
                turns: _controller,
                child: Icon(
                  Icons.refresh_rounded,
                  color: Colors.white.withValues(alpha: 0.94),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                widget.isLoading ? 'Đang cập nhật' : 'Làm mới',
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
