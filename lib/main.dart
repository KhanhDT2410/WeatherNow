import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather Now',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF0A84FF)),
        scaffoldBackgroundColor: const Color(0xFFF4F7FB),
        useMaterial3: true,
      ),
      home: const WeatherHomePage(),
    );
  }
}

class WeatherHomePage extends StatefulWidget {
  const WeatherHomePage({super.key, this.autoLoad = true});

  final bool autoLoad;

  @override
  State<WeatherHomePage> createState() => _WeatherHomePageState();
}

class _WeatherHomePageState extends State<WeatherHomePage> {
  WeatherReport? _report;
  Position? _position;
  String? _errorMessage;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoLoad) {
      _loadWeather();
    }
  }

  Future<void> _loadWeather() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final position = await _determinePosition();
      final report = await WeatherApi.fetchForecast(
        latitude: position.latitude,
        longitude: position.longitude,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _position = position;
        _report = report;
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (!mounted) {
        return;
      }

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Dich vu vi tri dang tat. Hay bat GPS tren thiet bi cua ban.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Ung dung chua duoc cap quyen truy cap vi tri.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Quyen vi tri da bi tu choi vinh vien. Hay mo cai dat de cap quyen lai.',
      );
    }

    return Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Du bao thoi tiet hien tai'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: _isLoading ? null : () => _loadWeather(),
            icon: const Icon(Icons.refresh),
            tooltip: 'Tai lai',
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE8F3FF),
              Color(0xFFF8FBFF),
            ],
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _loadWeather,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.all(16),
            children: [
              _HeaderCard(
                isLoading: _isLoading,
                position: _position,
                errorMessage: _errorMessage,
              ),
              const SizedBox(height: 16),
              if (_isLoading && _report == null)
                const _LoadingCard()
              else if (_report != null)
                ...[
                  _CurrentWeatherCard(report: _report!),
                  const SizedBox(height: 16),
                  Text(
                    'Du bao 5 ngay',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._report!.daily.map((dailyForecast) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _DailyForecastCard(forecast: dailyForecast),
                    );
                  }),
                ]
              else
                _EmptyStateCard(onPressed: _loadWeather),
            ],
          ),
        ),
      ),
    );
  }
}

class WeatherApi {
  static Future<WeatherReport> fetchForecast({
    required double latitude,
    required double longitude,
  }) async {
    final uri = Uri.https('api.open-meteo.com', '/v1/forecast', {
      'latitude': latitude.toString(),
      'longitude': longitude.toString(),
      'current':
          'temperature_2m,apparent_temperature,relative_humidity_2m,weather_code,wind_speed_10m,is_day',
      'daily': 'weather_code,temperature_2m_max,temperature_2m_min',
      'timezone': 'auto',
      'forecast_days': '5',
    });

    final response = await http.get(uri);
    if (response.statusCode != 200) {
      throw Exception('Khong the tai du lieu thoi tiet tu may chu.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherReport.fromJson(data);
  }
}

class WeatherReport {
  WeatherReport({
    required this.currentTemperature,
    required this.feelsLikeTemperature,
    required this.humidity,
    required this.windSpeed,
    required this.weatherCode,
    required this.isDay,
    required this.timezone,
    required this.daily,
  });

  final double currentTemperature;
  final double feelsLikeTemperature;
  final int humidity;
  final double windSpeed;
  final int weatherCode;
  final bool isDay;
  final String timezone;
  final List<DailyForecast> daily;

  factory WeatherReport.fromJson(Map<String, dynamic> json) {
    final current = json['current'] as Map<String, dynamic>;
    final dailyData = json['daily'] as Map<String, dynamic>;

    final times = List<String>.from(dailyData['time'] as List<dynamic>);
    final weatherCodes = List<int>.from(
      (dailyData['weather_code'] as List<dynamic>).map((item) => item as int),
    );
    final maxTemperatures = List<double>.from(
      (dailyData['temperature_2m_max'] as List<dynamic>)
          .map((item) => (item as num).toDouble()),
    );
    final minTemperatures = List<double>.from(
      (dailyData['temperature_2m_min'] as List<dynamic>)
          .map((item) => (item as num).toDouble()),
    );

    final dailyForecast = <DailyForecast>[];
    for (var index = 0; index < times.length; index++) {
      dailyForecast.add(
        DailyForecast(
          date: DateTime.parse(times[index]),
          weatherCode: weatherCodes[index],
          maxTemperature: maxTemperatures[index],
          minTemperature: minTemperatures[index],
        ),
      );
    }

    return WeatherReport(
      currentTemperature: (current['temperature_2m'] as num).toDouble(),
      feelsLikeTemperature:
          (current['apparent_temperature'] as num).toDouble(),
      humidity: (current['relative_humidity_2m'] as num).toInt(),
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      weatherCode: (current['weather_code'] as num).toInt(),
      isDay: (current['is_day'] as num).toInt() == 1,
      timezone: json['timezone'] as String? ?? 'auto',
      daily: dailyForecast,
    );
  }
}

class DailyForecast {
  DailyForecast({
    required this.date,
    required this.weatherCode,
    required this.maxTemperature,
    required this.minTemperature,
  });

  final DateTime date;
  final int weatherCode;
  final double maxTemperature;
  final double minTemperature;
}

class WeatherPresentation {
  const WeatherPresentation({
    required this.label,
    required this.icon,
    required this.color,
  });

  final String label;
  final IconData icon;
  final Color color;
}

WeatherPresentation weatherPresentationForCode(
  int code, {
  required bool isDay,
}) {
  if (code == 0) {
    return WeatherPresentation(
      label: 'Troi quang',
      icon: isDay ? Icons.sunny : Icons.nightlight_round,
      color: const Color(0xFFFFB703),
    );
  }

  if (code == 1 || code == 2) {
    return const WeatherPresentation(
      label: 'It may',
      icon: Icons.cloud_queue,
      color: Color(0xFF6C8DB6),
    );
  }

  if (code == 3) {
    return const WeatherPresentation(
      label: 'Nhieu may',
      icon: Icons.cloud,
      color: Color(0xFF5C6F8E),
    );
  }

  if (code == 45 || code == 48) {
    return const WeatherPresentation(
      label: 'Suong mu',
      icon: Icons.blur_on,
      color: Color(0xFF8193AE),
    );
  }

  if (code >= 51 && code <= 67) {
    return const WeatherPresentation(
      label: 'Mua',
      icon: Icons.grain,
      color: Color(0xFF1D6FD8),
    );
  }

  if (code >= 71 && code <= 77) {
    return const WeatherPresentation(
      label: 'Tuyet',
      icon: Icons.ac_unit,
      color: Color(0xFF67A8D8),
    );
  }

  if (code >= 80 && code <= 82) {
    return const WeatherPresentation(
      label: 'Mua rao',
      icon: Icons.shower,
      color: Color(0xFF1877F2),
    );
  }

  if (code >= 95 && code <= 99) {
    return const WeatherPresentation(
      label: 'Giong',
      icon: Icons.thunderstorm,
      color: Color(0xFF4E5D94),
    );
  }

  return const WeatherPresentation(
    label: 'Khong xac dinh',
    icon: Icons.cloud_outlined,
    color: Color(0xFF607D8B),
  );
}

String weekdayLabel(DateTime date) {
  const labels = <int, String>{
    DateTime.monday: 'Thu 2',
    DateTime.tuesday: 'Thu 3',
    DateTime.wednesday: 'Thu 4',
    DateTime.thursday: 'Thu 5',
    DateTime.friday: 'Thu 6',
    DateTime.saturday: 'Thu 7',
    DateTime.sunday: 'Chu nhat',
  };

  return labels[date.weekday] ?? 'Ngay';
}

class _HeaderCard extends StatelessWidget {
  const _HeaderCard({
    required this.isLoading,
    required this.position,
    required this.errorMessage,
  });

  final bool isLoading;
  final Position? position;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDDEBFF),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: const Icon(
                    Icons.my_location,
                    color: Color(0xFF0A84FF),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vi tri hien tai',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        position == null
                            ? 'Ung dung se xin quyen va doc toa do hien tai.'
                            : 'Lat ${position!.latitude.toStringAsFixed(4)} | '
                                'Lon ${position!.longitude.toStringAsFixed(4)}',
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (isLoading) ...[
              const SizedBox(height: 16),
              const LinearProgressIndicator(),
            ],
            if (errorMessage != null) ...[
              const SizedBox(height: 16),
              Text(
                errorMessage!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CurrentWeatherCard extends StatelessWidget {
  const _CurrentWeatherCard({required this.report});

  final WeatherReport report;

  @override
  Widget build(BuildContext context) {
    final weather = weatherPresentationForCode(
      report.weatherCode,
      isDay: report.isDay,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Thoi tiet luc nay',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '${report.currentTemperature.toStringAsFixed(1)} deg C',
                        style:
                            Theme.of(context).textTheme.displaySmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        weather.label,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              color: weather.color,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: weather.color.withOpacity(0.14),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Icon(weather.icon, size: 44, color: weather.color),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricChip(
                  icon: Icons.thermostat,
                  label: 'Cam giac',
                  value:
                      '${report.feelsLikeTemperature.toStringAsFixed(1)} deg C',
                ),
                _MetricChip(
                  icon: Icons.water_drop,
                  label: 'Do am',
                  value: '${report.humidity}%',
                ),
                _MetricChip(
                  icon: Icons.air,
                  label: 'Gio',
                  value: '${report.windSpeed.toStringAsFixed(1)} km/h',
                ),
                _MetricChip(
                  icon: Icons.public,
                  label: 'Mui gio',
                  value: report.timezone,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _DailyForecastCard extends StatelessWidget {
  const _DailyForecastCard({required this.forecast});

  final DailyForecast forecast;

  @override
  Widget build(BuildContext context) {
    final weather = weatherPresentationForCode(
      forecast.weatherCode,
      isDay: true,
    );

    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    weekdayLabel(forecast.date),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${forecast.date.day}/${forecast.date.month}/${forecast.date.year}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Icon(weather.icon, color: weather.color),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                weather.label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              '${forecast.maxTemperature.toStringAsFixed(0)} deg / '
              '${forecast.minTemperature.toStringAsFixed(0)} deg',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F8FF),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: const Color(0xFF0A84FF)),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return const Card(
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Expanded(
              child: Text('Dang lay vi tri va tai du lieu thoi tiet...'),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({required this.onPressed});

  final Future<void> Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Icon(Icons.wb_cloudy_outlined, size: 64),
            const SizedBox(height: 12),
            Text(
              'Nhan de xem thoi tiet theo vi tri hien tai',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Ung dung se xin quyen GPS va tai du lieu du bao trong 5 ngay.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => onPressed(),
              icon: const Icon(Icons.my_location),
              label: const Text('Lay du lieu thoi tiet'),
            ),
          ],
        ),
      ),
    );
  }
}
