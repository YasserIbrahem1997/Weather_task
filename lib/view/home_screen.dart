import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_journal/model/Weather_model.dart';
import 'package:weather_journal/view_model/weather_cubit/weather_cubit.dart';
import 'package:weather_journal/view_model/weather_cubit/weather_state.dart';
import 'details_screen.dart';
import 'search_weather_screen.dart';
import 'widget/weather_card.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Weather App'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<WeatherCubit, WeatherState>(
        builder: (context, state) {
          if (state is WeatherInitial) {
            context.read<WeatherCubit>().loadWeatherList();
            return Center(child: CircularProgressIndicator());
          }

          if (state is WeatherLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (state is WeatherError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error, size: 64, color: Colors.red),
                  SizedBox(height: 16),
                  Text(state.message, style: TextStyle(fontSize: 18)),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context.read<WeatherCubit>().loadWeatherList(),
                    child: Text('Try Again'),
                  ),
                ],
              ),
            );
          }

          if (state is WeatherLoaded) {
            if (state.weatherList.isEmpty) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.cloud_outlined, size: 100, color: Colors.grey),
                    SizedBox(height: 20),
                    Text(
                      'No Weather Data Yet',
                      style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Tap + to add your first city',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<WeatherCubit>().loadWeatherList();
              },
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: state.weatherList.length,
                itemBuilder: (context, index) {
                  final weather = state.weatherList[index];
                  return WeatherCard(
                    weather: weather,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailsScreen(weather: weather),
                      ),
                    ),
                    onDelete: () => _showDeleteDialog(context, weather),
                  );
                },
              ),
            );
          }

          return SizedBox();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
          context.read<WeatherCubit>().loadWeatherList();
        },
        backgroundColor: Colors.blue,
        child: Icon(Icons.search, color: Colors.white),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, Weather weather) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Are You Sure?'),
          content: Text('You Wont Delete data for ${weather.cityName}?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                context.read<WeatherCubit>().deleteWeather(weather.id!);
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
