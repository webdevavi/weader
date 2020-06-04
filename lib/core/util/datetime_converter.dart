import 'package:timezone/timezone.dart';
import 'package:intl/intl.dart';
import 'package:meta/meta.dart';

enum Format {
  Hours12,
  Hours24,
  Weekday,
  WeekdayWithDate,
}

class DateTimeConverter {
  DateTime convertUnixToHuman(int timestamp) =>
      DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);

  String convertUnix({
    @required int timestamp,
    Format format,
  }) {
    final _dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    switch (format) {
      case Format.Hours24:
        return DateFormat.Hm().format(_dateTime);
      case Format.Weekday:
        return DateFormat('EEEE').format(_dateTime);
      case Format.WeekdayWithDate:
        return DateFormat('EEEE, d MMM, yyyy').format(_dateTime);
      case Format.Hours12:
      default:
        return DateFormat.jm().format(_dateTime);
    }
  }

  String convertSpecificTimezone({
    @required int timestamp,
    @required String timezone,
    Format format,
  }) {
    final _dateTime = TZDateTime.fromMillisecondsSinceEpoch(
        getLocation(timezone), timestamp * 1000);
    switch (format) {
      case Format.Hours24:
        return DateFormat.Hm().format(_dateTime);
      case Format.Weekday:
        return DateFormat('EEEE').format(_dateTime);
      case Format.WeekdayWithDate:
        return DateFormat('EEEE, d MMM, yyyy').format(_dateTime);
      case Format.Hours12:
      default:
        return DateFormat.jm().format(_dateTime);
    }
  }

  String convertSpecificTimezoneToDay(
    int timestamp,
    String timezone,
  ) {
    Location location = getLocation(timezone);
    final DateTime _dateTime = TZDateTime.fromMillisecondsSinceEpoch(
      location,
      timestamp * 1000,
    );

    // final DateTime _now = DateTime.now();

    // final DateTime now = TZDateTime.from(_now, location);

    // final DateTime previousMidnight =
    //     DateTime(now.year, now.month, now.day - 1);

    // final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

    // final DateTime midnight = DateTime(now.year, now.month, now.day + 1);

    // final DateTime nextMidnight = DateTime(now.year, now.month, now.day + 2);

    // if (_dateTime.isBefore(lastMidnight) && _dateTime.isAfter(previousMidnight))
    //   return 'Yesterday';
    // if (_dateTime.isAfter(midnight) && _dateTime.isBefore(nextMidnight))
    //   return 'Tomorrow';
    // if (_dateTime.isAfter(lastMidnight) && _dateTime.isBefore(midnight))
    //   return 'Today';
    return DateFormat('EEEE').format(_dateTime);
  }

  String convertUnixToDay(int timestamp) {
    final DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    // final DateTime now = DateTime.now();

    // final DateTime previousMidnight =
    //     DateTime(now.year, now.month, now.day - 1);
    // final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

    // final DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    // final DateTime nextMidnight = DateTime(now.year, now.month, now.day + 2);

    // if (_dateTime.isBefore(lastMidnight) && _dateTime.isAfter(previousMidnight))
    //   return 'Yesterday';
    // if (_dateTime.isAfter(midnight) && _dateTime.isBefore(nextMidnight))
    //   return 'Tomorrow';
    // if (_dateTime.isAfter(lastMidnight) && _dateTime.isBefore(midnight))
    //   return 'Today';
    return DateFormat('EEEE').format(_dateTime);
  }
}
