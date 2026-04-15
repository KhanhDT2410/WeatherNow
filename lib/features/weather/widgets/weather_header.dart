import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';
import '../models/weather_report.dart';
import '../presentation/weather_formatters.dart';
import 'loading_refresh_button.dart';
import 'surface_card.dart';

class WeatherHeader extends StatelessWidget {
  const WeatherHeader({
    super.key,
    required this.report,
    required this.lastUpdated,
    required this.isLoading,
    required this.onRefresh,
  });

  final WeatherReport? report;
  final DateTime? lastUpdated;
  final bool isLoading;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final condition = report == null
        ? null
        : weatherPresentationForCode(report!.weatherCode, isDay: report!.isDay);

    return SurfaceCard(
      borderRadius: AppRadius.large,
      gradient: [const Color(0xE61B2B56), const Color(0xD9285BA6)],
      borderColor: Colors.white.withValues(alpha: 0.18),
      padding: const EdgeInsets.all(AppSpacing.xLarge),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final stacked = constraints.maxWidth < 760;

          final titleBlock = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Text(
                  report == null
                      ? 'Bảng điều khiển thời tiết'
                      : condition!.label,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(color: Colors.white),
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Text(
                'Dự báo thời tiết hiện tại',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                report == null
                    ? 'Theo dõi thời tiết theo vị trí hiện tại với giao diện đa nền tảng, trực quan và dễ quét.'
                    : 'Trải nghiệm thời tiết trực quan hơn với màu sắc, chuyển động và dữ liệu cập nhật theo vị trí.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Colors.white.withValues(alpha: 0.84),
                ),
              ),
              const SizedBox(height: AppSpacing.medium),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: [
                  const _HeaderPill(
                    icon: Icons.location_on_rounded,
                    label: 'Lấy dữ liệu theo vị trí hiện tại',
                  ),
                  const _HeaderPill(
                    icon: Icons.devices_rounded,
                    label: 'Tối ưu cho mobile, tablet và desktop',
                  ),
                  if (lastUpdated != null)
                    _HeaderPill(
                      icon: Icons.schedule_rounded,
                      label: lastUpdatedLabel(lastUpdated!),
                    ),
                ],
              ),
            ],
          );

          final sideBlock = Column(
            crossAxisAlignment: stacked
                ? CrossAxisAlignment.start
                : CrossAxisAlignment.end,
            children: [
              LoadingRefreshButton(isLoading: isLoading, onPressed: onRefresh),
              const SizedBox(height: AppSpacing.large),
              if (condition != null)
                Container(
                  padding: const EdgeInsets.all(AppSpacing.large),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(AppRadius.large),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.14),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: 64,
                        width: 64,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withValues(alpha: 0.16),
                        ),
                        child: Icon(
                          condition.icon,
                          size: 32,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.medium),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            formatTemperature(report!.currentTemperature),
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            condition.label,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: Colors.white.withValues(alpha: 0.92),
                                ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
            ],
          );

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                titleBlock,
                const SizedBox(height: AppSpacing.large),
                sideBlock,
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: titleBlock),
              const SizedBox(width: AppSpacing.large),
              sideBlock,
            ],
          );
        },
      ),
    );
  }
}

class _HeaderPill extends StatelessWidget {
  const _HeaderPill({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.86),
            ),
          ),
        ],
      ),
    );
  }
}
