import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dataClass.dart';

// if true, weekends are removed
bool isRemoveWeekend = true;

// min time and max time
int minTime = 9;
int maxTime = 20;

// week data array
var scheduleDataList = List.generate(7, (_) => WeekData());

// Save function
Future<void> saveData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> encodedData =
      scheduleDataList.map((week) => jsonEncode(week.toJson())).toList();
  await prefs.setStringList('scheduleData', encodedData);
  await prefs.setInt('minTime', minTime); // Save minTime
  await prefs.setInt('maxTime', maxTime); // Save maxTime
  await prefs.setBool('isRemoveWeekend', isRemoveWeekend); // Save isRemoveWeekend
}

// Load function
Future<void> loadData() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String>? encodedData = prefs.getStringList('scheduleData');

  if (encodedData != null && encodedData.isNotEmpty) {
    scheduleDataList = encodedData.map((jsonString) {
      return WeekData.fromJson(jsonDecode(jsonString));
    }).toList();
  } else {
    scheduleDataList = List.generate(7, (_) => WeekData());
  }

  minTime = prefs.getInt('minTime') ?? 6; // Load minTime with default 6
  maxTime = prefs.getInt('maxTime') ?? 24; // Load maxTime with default 24
  isRemoveWeekend = prefs.getBool('isRemoveWeekend') ?? true; // Load isRemoveWeekend with default true
}
