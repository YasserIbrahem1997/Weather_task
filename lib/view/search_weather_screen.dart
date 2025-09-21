
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_journal/view_model/search_cubit/search_cubit.dart';
import 'package:weather_journal/view_model/search_cubit/search_state.dart';


class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  final List<String> _cities = [
    'Cairo', 'Alexandria', 'Giza', 'Sharm El Sheikh', 'Hurghada', 'Luxor', 'Aswan',
    'London', 'Paris', 'Berlin', 'Madrid', 'Rome', 'Amsterdam', 'Vienna',
    'New York', 'Los Angeles', 'Chicago', 'Miami', 'San Francisco', 'Boston',
    'Tokyo', 'Seoul', 'Beijing', 'Shanghai', 'Hong Kong', 'Singapore', 'Bangkok',
    'Dubai', 'Abu Dhabi', 'Doha', 'Riyadh', 'Kuwait City', 'Muscat', 'Manama',
    'Sydney', 'Melbourne', 'Toronto', 'Vancouver', 'Montreal', 'Mumbai', 'Delhi'
  ];

  List<String> _filteredCities = [];

  @override
  void initState() {
    super.initState();
    _filteredCities = _cities;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _filterCities(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCities = _cities;
      } else {
        _filteredCities = _cities
            .where((city) => city.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Search Weather'),
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
        ),
        body: BlocConsumer<SearchCubit, SearchState>(
          listener: (context, state) {
            if (state is SearchSaved) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Weather saved successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            }

            if (state is SearchError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Search Card
                  Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        children: [
                          TextField(
                            controller: _controller,
                            onChanged: _filterCities,
                            decoration: InputDecoration(
                              labelText: 'City Name',
                              hintText: 'Type to search cities...',
                              prefixIcon: Icon(Icons.search),
                              border: OutlineInputBorder(),
                            ),
                            onSubmitted: (value) => _searchWeather(context),
                          ),
                          SizedBox(height: 16),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: state is SearchLoading
                                  ? null
                                  : () => _searchWeather(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                padding: EdgeInsets.symmetric(vertical: 15),
                              ),
                              child: state is SearchLoading
                                  ? CircularProgressIndicator(color: Colors.white)
                                  : Text(
                                'Search Weather',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 10),

                  // Cities Suggestions
                  if (_controller.text.isNotEmpty &&
                      _filteredCities.isNotEmpty &&
                      state is! SearchLoaded)
                    Card(
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Icon(Icons.location_city, color: Colors.blue),
                                SizedBox(width: 8),
                                Text(
                                  'Suggested Cities',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          ListView.builder(
                            shrinkWrap: true, // 🔥 مهم
                            physics: NeverScrollableScrollPhysics(), // 🔥 مهم
                            itemCount: _filteredCities.length > 10
                                ? 10
                                : _filteredCities.length,
                            itemBuilder: (context, index) {
                              final city = _filteredCities[index];
                              return ListTile(
                                leading: Icon(Icons.location_on, color: Colors.blue),
                                title: Text(city),
                                onTap: () {
                                  _controller.text = city;
                                  setState(() {
                                    _filteredCities = [];
                                  });
                                  _searchWeather(context);
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                  // Weather Results
                  if (state is SearchLoaded) ...[
                    SizedBox(height: 10),
                    Card(
                      color: Colors.blue,
                      child: Padding(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Icon(Icons.location_on, color: Colors.white),
                                SizedBox(width: 8),
                                Text(
                                  state.weather.cityName,
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  _getWeatherIcon(state.weather.condition),
                                  size: 60,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 20),
                                Column(
                                  children: [
                                    Text(
                                      '${state.weather.temperature.round()}°C',
                                      style: TextStyle(
                                        fontSize: 40,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    Text(
                                      state.weather.condition,
                                      style: TextStyle(
                                        fontSize: 18,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            Text(
                              state.weather.description,
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Icon(Icons.water_drop, color: Colors.white),
                                    SizedBox(height: 4),
                                    Text(
                                      'Humidity',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${state.weather.humidity}%',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                Column(
                                  children: [
                                    Icon(Icons.air, color: Colors.white),
                                    SizedBox(height: 4),
                                    Text(
                                      'Wind Speed',
                                      style: TextStyle(color: Colors.white70),
                                    ),
                                    Text(
                                      '${state.weather.windSpeed} m/s',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () =>
                                    context.read<SearchCubit>().saveWeather(state.weather),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: Colors.blue,
                                ),
                                child: Text(
                                  'Save Weather Data',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        )
    );
  }

  void _searchWeather(BuildContext context) {
    if (_controller.text.trim().isNotEmpty) {
      setState(() {
        _filteredCities = [];
      });
      context.read<SearchCubit>().searchWeather(_controller.text);
    }
  }

  IconData _getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.beach_access;
      case 'snow':
        return Icons.ac_unit;
      default:
        return Icons.wb_cloudy;
    }
  }
}