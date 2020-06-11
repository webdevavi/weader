import 'package:meta/meta.dart';

import '../../../../core/models/models.dart';
import '../../domain/entities/full_weather_list.dart';

class FullWeatherListModel extends FullWeatherList {
  final List<FullWeatherModel> fullWeatherList;

  FullWeatherListModel({@required this.fullWeatherList})
      : super(
          fullWeatherList: fullWeatherList,
        );
}
