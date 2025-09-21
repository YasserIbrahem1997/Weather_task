import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:weather_journal/model/Weather_model.dart';

import '../../main.dart';

class WeatherService {
  static const String _apiKey = '95e4444f4e376259a7b5a16d318fe26f';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  Future<Weather> getWeather(String cityName) async {
    final url = '$_baseUrl/weather?q=$cityName&appid=$_apiKey&units=metric';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return Weather.fromJson(data);
      } else if (response.statusCode == 404) {
        throw Exception('City not found');
      } else {
        throw Exception('Failed to get weather data');
      }
    } catch (e) {
      throw Exception('Network error');
    }
  }
}
