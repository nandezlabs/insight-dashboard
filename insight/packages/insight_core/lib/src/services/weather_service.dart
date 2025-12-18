import 'package:weather/weather.dart';

class WeatherService {
  final String apiKey;
  late WeatherFactory _weatherFactory;

  WeatherService({required this.apiKey}) {
    _weatherFactory = WeatherFactory(apiKey);
  }

  /// Get current weather by city name
  Future<Weather> getCurrentWeather(String city) async {
    try {
      return await _weatherFactory.currentWeatherByCityName(city);
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Get current weather by coordinates
  Future<Weather> getCurrentWeatherByLocation(
    double latitude,
    double longitude,
  ) async {
    try {
      return await _weatherFactory.currentWeatherByLocation(
        latitude,
        longitude,
      );
    } catch (e) {
      throw Exception('Failed to fetch weather: $e');
    }
  }

  /// Format weather for display
  static String formatWeather(Weather weather) {
    final temp = weather.temperature?.celsius?.round() ?? 0;
    final condition = weather.weatherDescription ?? 'Unknown';
    return '$temp°C, $condition';
  }

  /// Get weather icon based on condition
  static String getWeatherIcon(Weather weather) {
    final main = weather.weatherMain?.toLowerCase() ?? '';
    
    if (main.contains('clear')) return '☀️';
    if (main.contains('cloud')) return '☁️';
    if (main.contains('rain')) return '🌧️';
    if (main.contains('thunder')) return '⛈️';
    if (main.contains('snow')) return '❄️';
    if (main.contains('mist') || main.contains('fog')) return '🌫️';
    
    return '🌤️';
  }
}
