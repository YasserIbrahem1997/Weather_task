import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:weather_journal/view_model/database_halper/database_helper.dart';

import '../../main.dart';
import 'weather_state.dart';


class WeatherCubit extends Cubit<WeatherState> {
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  WeatherCubit() : super(WeatherInitial());

  Future<void> loadWeatherList() async {
    try {
      emit(WeatherLoading());
      final weatherList = await _databaseHelper.getAllWeather();
      emit(WeatherLoaded(weatherList));
    } catch (e) {
      emit(WeatherError('Failed to load data'));
    }
  }

  Future<void> deleteWeather(int id) async {
    try {
      await _databaseHelper.deleteWeather(id);
      loadWeatherList(); // Refresh list
    } catch (e) {
      emit(WeatherError('Failed to delete'));
    }
  }
}