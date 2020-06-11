import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../../../core/entities/entities.dart';

class FullWeatherList extends Equatable {
  final List<FullWeather> fullWeatherList;

  FullWeatherList({@required this.fullWeatherList});
  @override
  List<Object> get props => [fullWeatherList];
}
