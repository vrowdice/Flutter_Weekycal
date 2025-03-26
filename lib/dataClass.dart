import 'dart:convert';
import 'package:flutter/material.dart';

class WeekData {
  //week index
  int index = 0;
  //schedule list
  List<ScheduleData> scheduleInfo = [];

  // Convert Week object to JSON
  Map<String, dynamic> toJson() => {
        'index': index,
        'scheduleInfo':
            scheduleInfo.map((schedule) => schedule.toJson()).toList(),
      };

  // Create Week object from JSON
  WeekData.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    scheduleInfo = (json['scheduleInfo'] as List)
        .map((scheduleJson) => ScheduleData.fromJson(scheduleJson))
        .toList();
  }

  void sortSchedulesByStartTime() {
    scheduleInfo.sort((a, b) => a.startTime.compareTo(b.startTime));
  }

  String toJsonString() => jsonEncode(toJson());

  static WeekData fromJsonString(String jsonString) =>
      WeekData.fromJson(jsonDecode(jsonString));

  // Default constructor
  WeekData();
}

class ScheduleData {
  String name = "";
  String explanation = "";
  bool isAlarm = false;
  int startTime = 0;
  int endTime = 0;
  int alarmTime = 0;
  Color btnColor = Colors.white;

  DateTime getAlarmTime(int argMin) {
    //get now date
    DateTime today = DateTime.now();

    int hours = startTime ~/ 60;
    int minutes = startTime % 60;
    DateTime scheduleTime =
        DateTime(today.year, today.month, today.day, hours, minutes);
    
    return scheduleTime
        .subtract(Duration(minutes: argMin));
  }

  // Convert Schedule object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        'explanation': explanation,
        'btnColor': btnColor.value,
        'isAlarm': isAlarm,
        'alarmTime': alarmTime,
      };

  // Create Schedule object from JSON
  ScheduleData.fromJson(Map<String, dynamic> json) {
    name = json['name'] ?? "";
    startTime = json['startTime'] ?? 0;
    endTime = json['endTime'] ?? 0;
    explanation = json['explanation'] ?? "";
    btnColor = Color(json['btnColor'] ?? Colors.white.value);
    isAlarm = json['isAlarm'] ?? false;
    alarmTime = json['alarmTime'] ?? 0;
  }

  String toJsonString() => jsonEncode(toJson());

  static ScheduleData fromJsonString(String jsonString) =>
      ScheduleData.fromJson(jsonDecode(jsonString));

  // Default constructor
  ScheduleData();
}
