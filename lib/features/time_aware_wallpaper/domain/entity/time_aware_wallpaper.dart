import 'package:equatable/equatable.dart';

class TimeAwareWallpaper extends Equatable {
  final String url;

  TimeAwareWallpaper(this.url);

  @override 
  List<Object> get props => [url];
}