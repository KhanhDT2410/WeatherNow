import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';
import '../models/weather_report.dart';
import '../presentation/weather_formatters.dart';
import 'metric_chip.dart';
import 'surface_card.dart';

class CurrentWeatherCard extends StatelessWidget {
  const CurrentWeatherCard({super.key, required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    final weather = weatherPresentationForCode(
      report.weatherCode,
      isDay: report.isDay,
    );

    return Column(
      children: [
        SurfaceCard(
          borderRadius: AppRadius.large,
          gradient: [
            weather.gradient.first.withValues(alpha: 0.96),
            weather.gradient.last.withValues(alpha: 0.86),
          ],
          borderColor: Colors.white.withValues(alpha: 0.3),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final stacked = constraints.maxWidth < 680;

              final infoBlock = Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.16),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      'Thời tiết lúc này',
                      style: Theme.of(
                        context,
                      ).textTheme.labelLarge?.copyWith(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  Text(
                    formatTemperature(report.currentTemperature),
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    weather.label,
                    style: Theme.of(
                      context,
                    ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: AppSpacing.small),
                  Text(
                    currentSummary(report),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withValues(alpha: 0.86),
                    ),
                  ),
                ],
              );

              final iconBlock = Container(
                height: 128,
                width: 128,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.12),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(weather.icon, size: 72, color: Colors.white),
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    infoBlock,
                    const SizedBox(height: AppSpacing.large),
                    Align(alignment: Alignment.centerRight, child: iconBlock),
                  ],
                );
              }

              return Row(
                children: [
                  Expanded(child: infoBlock),
                  const SizedBox(width: AppSpacing.large),
                  iconBlock,
                ],
              );
            },
          ),
        ),
        const SizedBox(height: AppSpacing.medium),
        SurfaceCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Chỉ số chi tiết',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: AppSpacing.small),
              Text(
                'Những thông tin phụ nhưng rất hữu ích để đọc nhanh trạng thái thời tiết hiện tại.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
              ),
              const SizedBox(height: AppSpacing.large),
              Wrap(
                spacing: AppSpacing.medium,
                runSpacing: AppSpacing.medium,
                children: [
                  WeatherMetricChip(
                    icon: Icons.thermostat_rounded,
                    label: 'Cảm giác nhiệt độ',
                    value: formatTemperature(report.feelsLikeTemperature),
                    color: AppColors.accentWarm,
                  ),
                  WeatherMetricChip(
                    icon: Icons.water_drop_rounded,
                    label: 'Độ ẩm',
                    value: '${report.humidity}%',
                    color: const Color(0xFF18A0FB),
                  ),
                  WeatherMetricChip(
                    icon: Icons.air_rounded,
                    label: 'Gió',
                    value: '${report.windSpeed.toStringAsFixed(1)} km/h',
                    color: const Color(0xFF5C7CFA),
                  ),
                  WeatherMetricChip(
                    icon: Icons.public_rounded,
                    label: 'Múi giờ',
                    value: report.timezone,
                    color: const Color(0xFF7D5FFF),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
