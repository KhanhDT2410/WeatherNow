import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../../../theme/app_tokens.dart';
import '../models/weather_report.dart';
import '../services/weather_api.dart';
import '../widgets/current_weather_card.dart';
import '../widgets/forecast_section.dart';
import '../widgets/location_card.dart';
import '../widgets/motion_reveal.dart';
import '../widgets/state_cards.dart';
import '../widgets/weather_header.dart';
import '../widgets/weather_shell.dart';

class WeatherPage extends StatefulWidget {
  const WeatherPage({super.key, this.autoLoad = true});

  final bool autoLoad;

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherReport? _report;
  Position? _position;
  String? _errorMessage;
  DateTime? _lastUpdatedAt;
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
        _lastUpdatedAt = DateTime.now();
      });
    } catch (error) {
      if (!mounted) {
        return;
      }

      setState(() {
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<Position> _determinePosition() async {
    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      throw Exception(
        'Dịch vụ vị trí đang tắt. Hãy bật GPS hoặc Location Services trên thiết bị của bạn.',
      );
    }

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied) {
      throw Exception('Ứng dụng chưa được cấp quyền truy cập vị trí.');
    }

    if (permission == LocationPermission.deniedForever) {
      throw Exception(
        'Quyền vị trí đã bị từ chối vĩnh viễn. Hãy mở phần cài đặt để cấp quyền lại.',
      );
    }

    return Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WeatherShell(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isDesktop = constraints.maxWidth >= AppBreakpoints.desktop;

            final content = _buildStateContent(isDesktop: isDesktop);

            return RefreshIndicator(
              onRefresh: _loadWeather,
              color: AppColors.primaryDeep,
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.only(bottom: AppSpacing.xLarge),
                children: [
                  MotionReveal(
                    child: WeatherHeader(
                      report: _report,
                      lastUpdated: _lastUpdatedAt,
                      isLoading: _isLoading,
                      onRefresh: () => _loadWeather(),
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  MotionReveal(
                    delay: const Duration(milliseconds: 80),
                    child: LocationCard(
                      position: _position,
                      errorMessage: _errorMessage,
                      isLoading: _isLoading,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.large),
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    switchInCurve: Curves.easeOutCubic,
                    switchOutCurve: Curves.easeInCubic,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(
                        opacity: animation,
                        child: SlideTransition(
                          position: Tween<Offset>(
                            begin: const Offset(0, 0.04),
                            end: Offset.zero,
                          ).animate(animation),
                          child: child,
                        ),
                      );
                    },
                    child: content,
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStateContent({required bool isDesktop}) {
    if (_report == null && _isLoading) {
      return const LoadingStateCard(key: ValueKey('loading'));
    }

    if (_report == null && _errorMessage != null) {
      return ErrorStateCard(
        key: const ValueKey('error'),
        message: _errorMessage!,
        onRetry: _loadWeather,
      );
    }

    if (_report == null) {
      return EmptyStateCard(
        key: const ValueKey('empty'),
        onPressed: _loadWeather,
      );
    }

    if (!isDesktop) {
      return Column(
        key: const ValueKey('content-mobile'),
        children: [
          MotionReveal(
            delay: const Duration(milliseconds: 120),
            child: CurrentWeatherCard(report: _report!),
          ),
          const SizedBox(height: AppSpacing.large),
          MotionReveal(
            delay: const Duration(milliseconds: 180),
            child: ForecastSection(forecast: _report!.daily),
          ),
        ],
      );
    }

    return Row(
      key: const ValueKey('content-desktop'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: 6,
          child: MotionReveal(
            delay: const Duration(milliseconds: 120),
            child: CurrentWeatherCard(report: _report!),
          ),
        ),
        const SizedBox(width: AppSpacing.large),
        Expanded(
          flex: 5,
          child: MotionReveal(
            delay: const Duration(milliseconds: 180),
            child: ForecastSection(forecast: _report!.daily),
          ),
        ),
      ],
    );
  }
}
