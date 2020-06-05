import 'package:dartz/dartz.dart';

import '../../../../core/error/failures.dart';
import '../entity/time_aware_wallpaper.dart';

abstract class TimeAwareWallpaperRepository {
  Future<Either<Failure, TimeAwareWallpaper>> getWallpaper(String time);
}
