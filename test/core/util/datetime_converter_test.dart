import 'package:flutter_test/flutter_test.dart';
import 'package:Weader/core/util/datetime_converter.dart';
import 'package:timezone/timezone.dart';
import 'package:flutter/services.dart';

void main() {
  DateTimeConverter converter;

  Future<void> initTZ() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    var byteData = await rootBundle.load('packages/timezone/data/2020a.tzf');
    initializeDatabase(byteData.buffer.asUint8List());
  }

  setUp(() async {
    await initTZ();
    converter = DateTimeConverter();
  });

  final int tTimestamp = 1589526000;

  group(
    'local date time',
    () {
      final String tHours12Format = '12:30 PM';
      final String tHours24Format = '12:30';
      final String tWeekdayFormat = 'Friday';
      final String tWeekdayWithDateFormat = 'Friday, 15 May, 2020';
      test(
        'should return DateTime in 12 Hours format',
        () async {
          // act
          final result = converter.convertUnix(timestamp: tTimestamp);
          // assert
          expect(result, tHours12Format);
        },
      );
      test(
        'should return DateTime in 24 Hours format',
        () async {
          // act
          final result = converter.convertUnix(
            timestamp: tTimestamp,
            format: Format.Hours24,
          );
          // assert
          expect(result, tHours24Format);
        },
      );
      test(
        'should return DateTime in Weekday format',
        () async {
          // act
          final result = converter.convertUnix(
            timestamp: tTimestamp,
            format: Format.Weekday,
          );
          // assert
          expect(result, tWeekdayFormat);
        },
      );
      test(
        'should return DateTime in Weekday with date format',
        () async {
          // act
          final result = converter.convertUnix(
            timestamp: tTimestamp,
            format: Format.WeekdayWithDate,
          );
          // assert
          expect(result, tWeekdayWithDateFormat);
        },
      );
    },
  );

  group(
    'timezone specific date time',
    () {
      final String tTimezone = 'America/Detroit';
      final String tHours12Format = '3:00 AM';
      final String tHours24Format = '03:00';
      final String tWeekdayFormat = 'Friday';
      final String tWeekdayWithDateFormat = 'Friday, 15 May, 2020';

      test(
        'should return DateTime in 12 Hours format',
        () async {
          // act
          final result = converter.convertSpecificTimezone(
            timestamp: tTimestamp,
            timezone: tTimezone,
          );
          // assert
          expect(result, tHours12Format);
        },
      );
      test(
        'should return DateTime in 24 Hours format',
        () async {
          // act
          final result = converter.convertSpecificTimezone(
            timestamp: tTimestamp,
            timezone: tTimezone,
            format: Format.Hours24,
          ); // assert
          expect(result, tHours24Format);
        },
      );
      test(
        'should return DateTime in Weekday format',
        () async {
          // act
          final result = converter.convertSpecificTimezone(
            timestamp: tTimestamp,
            timezone: tTimezone,
            format: Format.Weekday,
          ); // a          // assert
          expect(result, tWeekdayFormat);
        },
      );
      test(
        'should return DateTime in Weekday with date format',
        () async {
          // act
          final result = converter.convertSpecificTimezone(
            timestamp: tTimestamp,
            timezone: tTimezone,
            format: Format.WeekdayWithDate,
          ); // a
          // assert
          expect(result, tWeekdayWithDateFormat);
        },
      );
    },
  );
}
