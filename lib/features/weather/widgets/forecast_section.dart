import 'package:flutter/material.dart';

import '../../../theme/app_tokens.dart';
import '../models/weather_report.dart';
import '../presentation/weather_formatters.dart';
import 'motion_reveal.dart';
import 'surface_card.dart';

class ForecastSection extends StatelessWidget {
  const ForecastSection({super.key, required this.forecast});

  final List<DailyForecast> forecast;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Dự báo 5 ngày', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: AppSpacing.small),
          Text(
            'Bố cục rõ ràng để quét nhanh xu hướng nhiệt độ và trạng thái thời tiết những ngày tới.',
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: AppColors.mutedText),
          ),
          const SizedBox(height: AppSpacing.large),
          LayoutBuilder(
            builder: (context, constraints) {
              final columns = constraints.maxWidth >= 820 ? 2 : 1;

              return GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: forecast.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  mainAxisSpacing: AppSpacing.medium,
                  crossAxisSpacing: AppSpacing.medium,
                  mainAxisExtent: 138,
                ),
                itemBuilder: (context, index) {
                  return MotionReveal(
                    delay: Duration(milliseconds: 80 * index),
                    child: ForecastItem(forecast: forecast[index]),
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class ForecastItem extends StatelessWidget {
  const ForecastItem({super.key, required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    final weather = weatherPresentationForCode(
      forecast.weatherCode,
      isDay: true,
    );

    return SurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.medium),
      gradient: [
        Colors.white.withValues(alpha: 0.94),
        weather.softColor.withValues(alpha: 0.72),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      weekdayLabel(forecast.date),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      shortDateLabel(forecast.date),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Container(
                height: 48,
                width: 48,
                decoration: BoxDecoration(
                  color: weather.accent.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(weather.icon, color: weather.accent),
              ),
            ],
          ),
          const Spacer(),
          Text(
            weather.label,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                formatCompactTemperature(forecast.maxTemperature),
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Text(
                formatCompactTemperature(forecast.minTemperature),
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.mutedText),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
