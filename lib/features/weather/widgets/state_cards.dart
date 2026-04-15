import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';
import 'surface_card.dart';

class LoadingStateCard extends StatefulWidget {
  const LoadingStateCard({super.key});

  @override
  State<LoadingStateCard> createState() => _LoadingStateCardState();
}

class _LoadingStateCardState extends State<LoadingStateCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, _) {
          final pulse = 0.35 + (_controller.value * 0.35);
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Đang lấy dữ liệu thời tiết...',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Ứng dụng đang kiểm tra quyền vị trí, đọc tọa độ hiện tại và đồng bộ dữ liệu dự báo mới nhất.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: AppSpacing.large),
              _SkeletonLine(widthFactor: 1, opacity: pulse),
              const SizedBox(height: AppSpacing.medium),
              _SkeletonLine(widthFactor: 0.72, opacity: pulse * 0.9),
              const SizedBox(height: AppSpacing.medium),
              _SkeletonLine(widthFactor: 0.88, opacity: pulse * 0.85),
              const SizedBox(height: AppSpacing.large),
              Row(
                children: List.generate(3, (index) {
                  return Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(
                        right: index == 2 ? 0 : AppSpacing.medium,
                      ),
                      child: _SkeletonBlock(opacity: pulse),
                    ),
                  );
                }),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ErrorStateCard extends StatelessWidget {
  const ErrorStateCard({
    super.key,
    required this.message,
    required this.onRetry,
  });

  final String message;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      gradient: const [Color(0xFFFFF2F2), Color(0xFFFFFCFC)],
      borderColor: const Color(0xFFFFD0D0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(
                  Icons.cloud_off_rounded,
                  color: AppColors.error,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Text(
                  'Không thể tải dữ liệu thời tiết',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            message,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.strongText),
          ),
          const SizedBox(height: AppSpacing.medium),
          Text(
            'Hãy kiểm tra mạng hoặc quyền truy cập vị trí rồi thử lại.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
          ),
          const SizedBox(height: AppSpacing.large),
          FilledButton.icon(
            onPressed: () => onRetry(),
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Thử lại'),
          ),
        ],
      ),
    );
  }
}

class EmptyStateCard extends StatelessWidget {
  const EmptyStateCard({super.key, required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        children: [
          Container(
            height: 96,
            width: 96,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF56CCF2).withValues(alpha: 0.2),
                  const Color(0xFF2F80ED).withValues(alpha: 0.2),
                ],
              ),
            ),
            child: const Icon(
              Icons.wb_cloudy_rounded,
              size: 48,
              color: AppColors.primaryDeep,
            ),
          ),
          const SizedBox(height: AppSpacing.large),
          Text(
            'Nhấn để xem thời tiết theo vị trí hiện tại',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Ứng dụng sẽ xin quyền GPS và tải dữ liệu dự báo 5 ngày với giao diện tối ưu cho nhiều kích thước màn hình.',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.mutedText),
          ),
          const SizedBox(height: AppSpacing.large),
          FilledButton.icon(
            onPressed: () => onPressed(),
            icon: const Icon(Icons.my_location_rounded),
            label: const Text('Lấy dữ liệu thời tiết'),
          ),
        ],
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  const _SkeletonLine({required this.widthFactor, required this.opacity});

  final double widthFactor;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Container(
        height: 16,
        decoration: BoxDecoration(
          color: AppColors.primaryDeep.withValues(alpha: opacity),
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SkeletonBlock extends StatelessWidget {
  const _SkeletonBlock({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 92,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: opacity * 0.7),
        borderRadius: BorderRadius.circular(AppRadius.small),
      ),
    );
  }
}
