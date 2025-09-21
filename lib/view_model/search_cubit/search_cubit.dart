import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_journal/model/Weather_model.dart';
import 'package:weather_journal/view_model/database_halper/database_helper.dart';
import 'package:weather_journal/view_model/database_halper/weather_service.dart';

import '../../main.dart';
import 'search_state.dart';

class SearchCubit extends Cubit<SearchState> {
  final WeatherService _weatherService = WeatherService();
  final DatabaseHelper _databaseHelper = DatabaseHelper();

  SearchCubit() : super(SearchInitial());

  Future<void> searchWeather(String cityName) async {
    if (cityName.trim().isEmpty) {
      emit(SearchError('Please enter city name'));
      return;
    }

    try {
      emit(SearchLoading());
      final weather = await _weatherService.getWeather(cityName);
      emit(SearchLoaded(weather));
    } catch (e) {
      emit(SearchError('City not found'));
    }
  }

  Future<void> saveWeather(Weather weather) async {
    try {
      // Check if city already exists
      final exists = await _databaseHelper.cityExists(weather.cityName);
      if (exists) {
        emit(SearchError('City already saved!'));
        return;
      }

      await _databaseHelper.insertWeather(weather);
      emit(SearchSaved());
    } catch (e) {
      emit(SearchError('Failed to save'));
    }
  }

  void reset() {
    emit(SearchInitial());
  }
}
