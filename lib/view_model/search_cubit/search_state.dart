


// Search Screen States
import 'package:equatable/equatable.dart';
import 'package:weather_journal/model/Weather_model.dart';

import '../../main.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final Weather weather;
  SearchLoaded(this.weather);

  @override
  List<Object?> get props => [weather];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class SearchSaved extends SearchState {}
