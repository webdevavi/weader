import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:weader/core/error/failures.dart';
import 'package:weader/features/time_aware_wallpaper/domain/usecases/get_wallpaper.dart';
import './bloc.dart';

class TimeAwareWallpaperBloc
    extends Bloc<TimeAwareWallpaperEvent, TimeAwareWallpaperState> {
  final GetWallpaper getWallpaper;

  TimeAwareWallpaperBloc(this.getWallpaper) : assert(getWallpaper != null);

  @override
  TimeAwareWallpaperState get initialState => TimeAwareWallpaperEmpty();

  @override
  Stream<TimeAwareWallpaperState> mapEventToState(
    TimeAwareWallpaperEvent event,
  ) async* {
    if (event is GetWallpaperEvent) {
      yield TimeAwareWallpaperLoading();
      final timeAwareWallpaperEither = await getWallpaper(
        Params(
          time: event.time,
        ),
      );

      yield* timeAwareWallpaperEither.fold((failure) async* {
        yield TimeAwareWallpaperError(message: mapFailureToMessage(failure));
      }, (timeAwareWallpaper) async* {
        yield TimeAwareWallpaperLoaded(timeAwareWallpaper: timeAwareWallpaper);
      });
    }
  }
}
