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

  DateTime convertUnixToHumanTZ(
    int timestamp,
    String timezone,
  ) =>
      TZDateTime.fromMillisecondsSinceEpoch(
        getLocation(timezone),
        timestamp * 1000,
      );

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

    final DateTime _now = DateTime.now();

    final DateTime now = TZDateTime.from(_now, location);

    final DateTime previousMidnight =
        TZDateTime(location, now.year, now.month, now.day - 1);

    final DateTime lastMidnight =
        TZDateTime(location, now.year, now.month, now.day);

    final DateTime midnight =
        TZDateTime(location, now.year, now.month, now.day + 1);

    final DateTime nextMidnight =
        TZDateTime(location, now.year, now.month, now.day + 2);

    return toDaySchema(
      _dateTime,
      previousMidnight,
      lastMidnight,
      midnight,
      nextMidnight,
    );
  }

  String convertUnixToDay(int timestamp) {
    final DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(
      timestamp * 1000,
    );
    final DateTime now = DateTime.now();

    final DateTime previousMidnight =
        DateTime(now.year, now.month, now.day - 1);
    final DateTime lastMidnight = DateTime(now.year, now.month, now.day);

    final DateTime midnight = DateTime(now.year, now.month, now.day + 1);
    final DateTime nextMidnight = DateTime(now.year, now.month, now.day + 2);

    return toDaySchema(
      _dateTime,
      previousMidnight,
      lastMidnight,
      midnight,
      nextMidnight,
    );
  }

  String toDaySchema(
    _dateTime, [
    DateTime previousMidnight,
    DateTime lastMidnight,
    DateTime midnight,
    DateTime nextMidnight,
  ]) {
    if (_dateTime.isBefore(
              lastMidnight,
            ) &&
            _dateTime.isAfter(
              previousMidnight,
            ) ||
        _dateTime.isAtSameMomentAs(
          previousMidnight,
        )) return 'Yesterday';

    if (_dateTime.isAfter(
              midnight,
            ) &&
            _dateTime.isBefore(
              nextMidnight,
            ) ||
        _dateTime.isAtSameMomentAs(
          midnight,
        )) return 'Tomorrow';
    if (_dateTime.isAfter(
              lastMidnight,
            ) &&
            _dateTime.isBefore(
              midnight,
            ) ||
        _dateTime.isAtSameMomentAs(
          lastMidnight,
        ))
      return 'Today';
    else
      return DateFormat('EEEE').format(_dateTime);
  }

  String getDaytimeTZ(
    int timestamp,
    String timezone,
  ) {
    Location location = getLocation(timezone);
    DateTime _dateTime =
        TZDateTime.fromMillisecondsSinceEpoch(location, timestamp * 1000);
    //4:00 - 7:30 sunrise
    if (_dateTime.isAfter(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            4,
            00,
          ),
        ) &&
        _dateTime.isBefore(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            7,
            30,
          ),
        )) return 'sunrise';

    //7:30 - 12:00 morning
    if (_dateTime.isAfter(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            7,
            30,
          ),
        ) &&
        _dateTime.isBefore(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            12,
            00,
          ),
        )) return 'morning';
    //12:00 - 16:00 afternoon
    if (_dateTime.isAfter(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            12,
            00,
          ),
        ) &&
        _dateTime.isBefore(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            16,
            00,
          ),
        )) return 'afternoon';

    //16:00 - 18:00 evening
    if (_dateTime.isAfter(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            16,
            00,
          ),
        ) &&
        _dateTime.isBefore(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            18,
            00,
          ),
        )) return 'evening';

    //18:00 - 19:00 sunset
    if (_dateTime.isAfter(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            18,
            00,
          ),
        ) &&
        _dateTime.isBefore(
          TZDateTime(
            location,
            _dateTime.year,
            _dateTime.month,
            _dateTime.day,
            19,
            00,
          ),
        )) return 'sunset';

    //7 AM - 4AM night
    return 'night';
  }

  String getDayTime(int timestamp) {
    DateTime _dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    //4:00 - 7:30 sunrise
    if (_dateTime.isAfter(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 4, 00)) &&
        _dateTime.isBefore(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 7, 30)))
      return 'sunrise';

    //7:30 - 12:00 morning
    if (_dateTime.isAfter(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 7, 30)) &&
        _dateTime.isBefore(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 12, 00)))
      return 'morning';
    //12:00 - 16:00 afternoon
    if (_dateTime.isAfter(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 12, 00)) &&
        _dateTime.isBefore(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 16, 00)))
      return 'afternoon';

    //16:00 - 18:00 evening
    if (_dateTime.isAfter(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 16, 00)) &&
        _dateTime.isBefore(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 18, 00)))
      return 'evening';

    //18:00 - 19:00 sunset
    if (_dateTime.isAfter(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 18, 00)) &&
        _dateTime.isBefore(
            DateTime(_dateTime.year, _dateTime.month, _dateTime.day, 19, 00)))
      return 'sunset';

    //7 AM - 4AM night
    return 'night';
  }
}
