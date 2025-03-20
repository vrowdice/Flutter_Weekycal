import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'dataClass.dart';
import 'main.dart';

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

// Save schedule data (without minTime, maxTime, isRemoveWeekend)
Future<void> saveScheduleData(String argSaveName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String> encodedData =
      scheduleDataList.map((week) => jsonEncode(week.toJson())).toList();

  await prefs.setStringList('scheduleData_$argSaveName', encodedData);

  List<String> saveList = prefs.getStringList('saveList') ?? [];
  if (!saveList.contains(argSaveName)) {
    saveList.add(argSaveName);
    await prefs.setStringList('saveList', saveList);
  }
}

// Load saved data (without minTime, maxTime, isRemoveWeekend)
Future<void> loadScheduleData(String argLoadName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  List<String>? encodedData = prefs.getStringList('scheduleData_$argLoadName');

  if (encodedData != null && encodedData.isNotEmpty) {
    scheduleDataList = encodedData.map((jsonString) {
      return WeekData.fromJson(jsonDecode(jsonString));
    }).toList();
  } else {
    scheduleDataList = List.generate(7, (_) => WeekData());
  }
  
  syncData();
  updateHomeWidget();
}

// Delete schedule data
Future<void> deleteScheduleData(String argDeleteName) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  await prefs.remove('scheduleData_$argDeleteName');

  // Update save list
  List<String> saveList = prefs.getStringList('saveList') ?? [];
  saveList.remove(argDeleteName);
  await prefs.setStringList('saveList', saveList);
}

// Load saved list (sorted)
Future<List<String>> getSavedScheduleList() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  List<String> saveList = prefs.getStringList('saveList') ?? [];

  saveList.sort();

  return saveList;
}
