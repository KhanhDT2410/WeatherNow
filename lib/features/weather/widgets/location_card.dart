import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../theme/app_tokens.dart';
import 'surface_card.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.position,
    required this.errorMessage,
    required this.isLoading,
  });

  final Position? position;
  final String? errorMessage;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: const Color(0xFFE3F3FF),
                  borderRadius: BorderRadius.circular(AppRadius.small),
                ),
                child: const Icon(
                  Icons.my_location_rounded,
                  color: AppColors.primaryDeep,
                ),
              ),
              const SizedBox(width: AppSpacing.medium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Vị trí hiện tại',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      position == null
                          ? 'Ứng dụng sẽ xin quyền truy cập vị trí để lấy dự báo chính xác hơn.'
                          : 'Lat ${position!.latitude.toStringAsFixed(4)} • '
                                'Lon ${position!.longitude.toStringAsFixed(4)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.mutedText,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.large),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              _StatusChip(
                color: errorMessage == null
                    ? AppColors.success
                    : AppColors.error,
                icon: errorMessage == null
                    ? Icons.check_circle_rounded
                    : Icons.error_rounded,
                label: errorMessage == null
                    ? 'Định vị sẵn sàng'
                    : 'Cần kiểm tra quyền vị trí',
              ),
              _StatusChip(
                color: const Color(0xFF7A8CFF),
                icon: isLoading ? Icons.sync_rounded : Icons.radar_rounded,
                label: isLoading
                    ? 'Đang làm mới dữ liệu'
                    : 'Đồng bộ theo thời gian thực',
              ),
            ],
          ),
          if (errorMessage != null) ...[
            const SizedBox(height: AppSpacing.medium),
            Text(
              errorMessage!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.error,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({
    required this.color,
    required this.icon,
    required this.label,
  });

  final Color color;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
