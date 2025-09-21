import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


import 'view/home_screen.dart';
import 'view_model/search_cubit/search_cubit.dart';
import 'view_model/weather_cubit/weather_cubit.dart';


void main() {
  runApp(WeatherApp());
}

class WeatherApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>   WeatherCubit(),
        ),
        BlocProvider(
          create: (context) =>   SearchCubit(),
        ),

      ],
      child: MaterialApp(
        title: 'Weather Journal',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        home: HomeScreen(),
      ),
    );
  }
}

