
// Home Screen States
import 'package:equatable/equatable.dart';
import 'package:weather_journal/model/Weather_model.dart';

import '../../main.dart';

abstract class WeatherState extends Equatable {
  @override
  List<Object?> get props => [];
}

class WeatherInitial extends WeatherState {}
class WeatherLoading extends WeatherState {}

class WeatherLoaded extends WeatherState {
  final List<Weather> weatherList;
  WeatherLoaded(this.weatherList);

  @override
  List<Object?> get props => [weatherList];
}

class WeatherError extends WeatherState {
  final String message;
  WeatherError(this.message);

  @override
  List<Object?> get props => [message];
}