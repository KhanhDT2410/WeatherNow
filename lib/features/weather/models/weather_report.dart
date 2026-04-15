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
      (dailyData['temperature_2m_max'] as List<dynamic>).map(
        (item) => (item as num).toDouble(),
      ),
    );
    final minTemperatures = List<double>.from(
      (dailyData['temperature_2m_min'] as List<dynamic>).map(
        (item) => (item as num).toDouble(),
      ),
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
      feelsLikeTemperature: (current['apparent_temperature'] as num).toDouble(),
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
