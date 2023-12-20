import 'dart:async';

import 'package:device_calendar/device_calendar.dart';
import 'package:timezone/timezone.dart';
Future<List<Calendar>?> retrieveCalendars() async {
  try {
    DeviceCalendarPlugin _deviceCalendarPlugin = DeviceCalendarPlugin();
    var permissionsGranted = await _deviceCalendarPlugin.hasPermissions();
    if (permissionsGranted.isSuccess && !permissionsGranted.data!) {
      permissionsGranted = await _deviceCalendarPlugin.requestPermissions();
      if (!permissionsGranted.isSuccess || !permissionsGranted.data!) {
        return [];
      }
    }

    final calendarsResult = await _deviceCalendarPlugin.retrieveCalendars();

    return calendarsResult.data;
  } catch (e) {
    print(e);
    return [];
  }
}

Future<bool> addEventsToCalendar({
  required Calendar calendar,
  required String eventId,
  required String eventTitle,
  required DateTime eventStartTime,
  required String eventDescription,
  int eventDuration: 1,
}) async {
  try {
    if (calendar.isReadOnly!) {
      return false;
    }

    final eventToCreate = Event(
      calendar.id,
      eventId: "$eventId",
      title: "$eventTitle",
      start: eventStartTime as TZDateTime?,
      description: "$eventDescription",
      end: eventStartTime.add(Duration(hours: eventDuration)) as TZDateTime?,
    );

    final createEventResult =
        await (DeviceCalendarPlugin().createOrUpdateEvent(eventToCreate) as FutureOr<Result<String>>);
    if (createEventResult.isSuccess &&
        (createEventResult.data?.isNotEmpty ?? false)) {
      return true;
    }
    return false;
  } catch (e) {
    print(e);
    return false;
  }
}
