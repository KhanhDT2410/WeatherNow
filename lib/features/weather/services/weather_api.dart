import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/weather_report.dart';

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
      throw Exception('Không thể tải dữ liệu thời tiết từ máy chủ.');
    }

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    return WeatherReport.fromJson(data);
  }
}
