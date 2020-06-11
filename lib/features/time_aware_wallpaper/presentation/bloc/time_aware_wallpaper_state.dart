import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../domain/entity/time_aware_wallpaper.dart';

@immutable
abstract class TimeAwareWallpaperState extends Equatable {
  TimeAwareWallpaperState();
}

class TimeAwareWallpaperEmpty extends TimeAwareWallpaperState {
  @override
  List<Object> get props => [];
}

class TimeAwareWallpaperLoading extends TimeAwareWallpaperState {
  @override
  List<Object> get props => [];
}

class TimeAwareWallpaperLoaded extends TimeAwareWallpaperState {
  final TimeAwareWallpaper timeAwareWallpaper;

  TimeAwareWallpaperLoaded({@required this.timeAwareWallpaper});
  @override
  List<Object> get props => [timeAwareWallpaper];
}

class TimeAwareWallpaperError extends TimeAwareWallpaperState {
  final String message;

  TimeAwareWallpaperError({@required this.message});
  @override
  List<Object> get props => [message];
}
