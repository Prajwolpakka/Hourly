import 'package:hourly/Models/AlarmData.dart';
import 'package:hourly/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/timezone.dart' as tz;

//.wav file
class AlarmProvider extends ChangeNotifier {
  List<AlarmData> _alarmList = [];
  bool _fetching;

  AlarmProvider() {
    for (int i = 0; i < 24; i++) {
      String key;
      if (i < 12) {
        key = i.toString();
        if (key == '0') key = '12';
        if (key.length == 1) key = "0" + key;
        _alarmList.add(AlarmData(time: i, key: key + " AM"));
      } else {
        key = (i - 12).toString();
        if (key == '0') key = '12';
        if (key.length == 1) key = "0" + key;
        _alarmList.add(AlarmData(time: i, key: key + " PM"));
      }
    }
    _fetchData();
  }

  Future<void> _fetchData() async {
    print('Fetching Alarm Data');
    _fetching = true;

    final prefs = await SharedPreferences.getInstance();
    for (AlarmData alarms in _alarmList) {
      alarms.status = prefs.getBool(alarms.key) ?? false;
    }
    _fetching = false;
    notifyListeners();
  }

  List<AlarmData> get alarmList => _alarmList;
  bool get fetching => _fetching;
  int get alarmLength => _alarmList.length;

  alarmStatus(int index, bool status) async {
    _alarmList[index].status = !_alarmList[index].status;
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(_alarmList[index].key, status);
    if (status == true) {
      scheduleAlarm(_alarmList[index]);
    } else {
      cancelAlarm(_alarmList[index]);
    }
    notifyListeners();
  }
}

void scheduleAlarm(AlarmData alarm) async {
  String value = 'a' + alarm.time.toString();
  print(value);
  await flutterLocalNotificationsPlugin.zonedSchedule(
    alarm.time,
    "It's " + alarm.key.toLowerCase() + '.',
    null,
    _nextInstance(alarm.time),
    NotificationDetails(
      android: AndroidNotificationDetails(
        value,
        'Notification at ${alarm.key.toLowerCase()}',
        null,
        importance: Importance.max,
        priority: Priority.max,
        sound: RawResourceAndroidNotificationSound(value),
      ),
    ),
    androidAllowWhileIdle: true,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    matchDateTimeComponents: DateTimeComponents.time,
  );
}

Future<void> cancelAlarm(AlarmData alarm) async {
  await flutterLocalNotificationsPlugin.cancel(alarm.time);
}

tz.TZDateTime _nextInstance(int time) {
  final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
  tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month, now.day, time);
  if (scheduledDate.isBefore(now)) scheduledDate = scheduledDate.add(const Duration(days: 1));
  return scheduledDate;
}
