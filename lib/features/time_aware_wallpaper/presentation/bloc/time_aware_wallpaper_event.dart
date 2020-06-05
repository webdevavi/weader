import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class TimeAwareWallpaperEvent extends Equatable {
  TimeAwareWallpaperEvent();
}

class GetWallpaperEvent extends TimeAwareWallpaperEvent {
  final String time;

  GetWallpaperEvent(this.time);
  @override
  List<Object> get props => [time];
}
