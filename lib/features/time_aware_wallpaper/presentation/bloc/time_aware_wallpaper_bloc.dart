import 'dart:async';

import 'package:bloc/bloc.dart';

import './bloc.dart';
import '../../../../core/error/failures.dart';
import '../../domain/usecases/get_wallpaper.dart';

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
