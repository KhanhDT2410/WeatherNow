import 'package:flutter/material.dart';

import '../features/weather/presentation/weather_page.dart';
import '../theme/app_theme.dart';

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key, this.home});

  final Widget? home;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Bảng điều khiển thời tiết',
      theme: AppTheme.light(),
      home: home ?? const WeatherPage(),
    );
  }
}
