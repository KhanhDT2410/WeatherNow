import 'package:flutter/material.dart';

import '../models/weather_report.dart';

class WeatherPresentation {
  const WeatherPresentation({
    required this.label,
    required this.icon,
    required this.accent,
    required this.gradient,
    required this.softColor,
  });

  final String label;
  final IconData icon;
  final Color accent;
  final List<Color> gradient;
  final Color softColor;
}

WeatherPresentation weatherPresentationForCode(
  int code, {
  required bool isDay,
}) {
  if (code == 0) {
    return WeatherPresentation(
      label: 'Trời quang',
      icon: isDay ? Icons.wb_sunny_rounded : Icons.nightlight_round,
      accent: const Color(0xFFFFB84D),
      gradient: const [Color(0xFF1D9BF0), Color(0xFF76D1FF)],
      softColor: const Color(0xFFFFF1C7),
    );
  }

  if (code == 1 || code == 2) {
    return const WeatherPresentation(
      label: 'Ít mây',
      icon: Icons.cloud_queue_rounded,
      accent: Color(0xFF7BB2FF),
      gradient: [Color(0xFF3C7BFF), Color(0xFF8CC8FF)],
      softColor: Color(0xFFE0EEFF),
    );
  }

  if (code == 3) {
    return const WeatherPresentation(
      label: 'Nhiều mây',
      icon: Icons.cloud_rounded,
      accent: Color(0xFF6D89B4),
      gradient: [Color(0xFF506C97), Color(0xFF91AACC)],
      softColor: Color(0xFFE6EDF8),
    );
  }

  if (code == 45 || code == 48) {
    return const WeatherPresentation(
      label: 'Sương mù',
      icon: Icons.blur_on_rounded,
      accent: Color(0xFF8EA0B8),
      gradient: [Color(0xFF64748B), Color(0xFFA7B3C5)],
      softColor: Color(0xFFE8EDF3),
    );
  }

  if (code >= 51 && code <= 67) {
    return const WeatherPresentation(
      label: 'Mưa',
      icon: Icons.grain_rounded,
      accent: Color(0xFF2596FF),
      gradient: [Color(0xFF1D63E0), Color(0xFF52C8FF)],
      softColor: Color(0xFFDDF2FF),
    );
  }

  if (code >= 71 && code <= 77) {
    return const WeatherPresentation(
      label: 'Tuyết',
      icon: Icons.ac_unit_rounded,
      accent: Color(0xFF78B4E3),
      gradient: [Color(0xFF4E87C9), Color(0xFFB0DBFF)],
      softColor: Color(0xFFE8F6FF),
    );
  }

  if (code >= 80 && code <= 82) {
    return const WeatherPresentation(
      label: 'Mưa rào',
      icon: Icons.shower_rounded,
      accent: Color(0xFF1877F2),
      gradient: [Color(0xFF1257C5), Color(0xFF57B7FF)],
      softColor: Color(0xFFDDEFFF),
    );
  }

  if (code >= 95 && code <= 99) {
    return const WeatherPresentation(
      label: 'Giông',
      icon: Icons.thunderstorm_rounded,
      accent: Color(0xFF7367F0),
      gradient: [Color(0xFF493CA7), Color(0xFF7A8CFF)],
      softColor: Color(0xFFE6E3FF),
    );
  }

  return const WeatherPresentation(
    label: 'Không xác định',
    icon: Icons.cloud_outlined,
    accent: Color(0xFF607D8B),
    gradient: [Color(0xFF506D7B), Color(0xFF91A6B2)],
    softColor: Color(0xFFE8EEF1),
  );
}

String weekdayLabel(DateTime date) {
  const labels = <int, String>{
    DateTime.monday: 'Thứ 2',
    DateTime.tuesday: 'Thứ 3',
    DateTime.wednesday: 'Thứ 4',
    DateTime.thursday: 'Thứ 5',
    DateTime.friday: 'Thứ 6',
    DateTime.saturday: 'Thứ 7',
    DateTime.sunday: 'Chủ nhật',
  };

  return labels[date.weekday] ?? 'Hôm nay';
}

String shortDateLabel(DateTime date) {
  return '${date.day.toString().padLeft(2, '0')}/'
      '${date.month.toString().padLeft(2, '0')}/'
      '${date.year}';
}

String formatTemperature(double temperature) {
  return '${temperature.toStringAsFixed(1)}°C';
}

String formatCompactTemperature(double temperature) {
  return '${temperature.toStringAsFixed(0)}°C';
}

String currentSummary(WeatherReport report) {
  return 'Cảm giác như ${formatTemperature(report.feelsLikeTemperature)}'
      ' • Độ ẩm ${report.humidity}%';
}

String lastUpdatedLabel(DateTime updatedAt) {
  final hour = updatedAt.hour.toString().padLeft(2, '0');
  final minute = updatedAt.minute.toString().padLeft(2, '0');
  return 'Cập nhật lúc $hour:$minute';
}
