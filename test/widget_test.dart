import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_application_1/app/weather_app.dart';
import 'package:flutter_application_1/features/weather/models/weather_report.dart';
import 'package:flutter_application_1/features/weather/presentation/weather_formatters.dart';
import 'package:flutter_application_1/features/weather/widgets/current_weather_card.dart';

void main() {
  test('Chuỗi tiếng Việt và formatter hiển thị đúng', () {
    expect(weatherPresentationForCode(3, isDay: true).label, 'Nhiều mây');
    expect(weatherPresentationForCode(95, isDay: true).label, 'Giông');
    expect(weekdayLabel(DateTime(2026, 4, 19)), 'Chủ nhật');
    expect(formatTemperature(27.4), '27.4°C');
  });

  testWidgets('CurrentWeatherCard hiển thị nhiệt độ nổi bật', (
    WidgetTester tester,
  ) async {
    final report = WeatherReport(
      currentTemperature: 29.4,
      feelsLikeTemperature: 32.1,
      humidity: 74,
      windSpeed: 12.3,
      weatherCode: 3,
      isDay: true,
      timezone: 'Asia/Ho_Chi_Minh',
      daily: [
        DailyForecast(
          date: DateTime(2026, 4, 15),
          weatherCode: 3,
          maxTemperature: 31,
          minTemperature: 25,
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: CurrentWeatherCard(report: report)),
      ),
    );

    expect(find.text('Thời tiết lúc này'), findsOneWidget);
    expect(find.text('29.4°C'), findsOneWidget);
    expect(find.text('Nhiều mây'), findsOneWidget);
  });

  testWidgets('WeatherApp nhận home override để phục vụ test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      const WeatherApp(home: Scaffold(body: Text('Kiểm thử'))),
    );

    expect(find.text('Kiểm thử'), findsOneWidget);
  });
}
