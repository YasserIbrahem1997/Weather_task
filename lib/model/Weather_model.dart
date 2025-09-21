

// lib/models/weather.dart
class Weather {
  final int? id;
  final String cityName;
  final double temperature;
  final String condition;
  final int humidity;
  final double windSpeed;
  final String description;

  Weather({
    this.id,
    required this.cityName,
    required this.temperature,
    required this.condition,
    required this.humidity,
    required this.windSpeed,
    required this.description,
  });

  // From API JSON
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      condition: json['weather'][0]['main'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      description: json['weather'][0]['description'],
    );
  }

  // To Database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cityName': cityName,
      'temperature': temperature,
      'condition': condition,
      'humidity': humidity,
      'windSpeed': windSpeed,
      'description': description,
    };
  }

  // From Database
  factory Weather.fromMap(Map<String, dynamic> map) {
    return Weather(
      id: map['id'],
      cityName: map['cityName'],
      temperature: map['temperature'],
      condition: map['condition'],
      humidity: map['humidity'],
      windSpeed: map['windSpeed'],
      description: map['description'],
    );
  }
}
