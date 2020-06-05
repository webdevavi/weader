import 'package:weader/features/time_aware_wallpaper/domain/entity/time_aware_wallpaper.dart';

class TimeAwareWallpaperModel extends TimeAwareWallpaper {
  TimeAwareWallpaperModel(
    String url,
  ) : super(url);

  factory TimeAwareWallpaperModel.fromJson(Map<String, dynamic> json) {
    return TimeAwareWallpaperModel(json['urls']['small']);
  }

  Map<String, String> toJson() => {"url": url};
}
