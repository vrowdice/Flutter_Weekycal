import 'package:flutter/material.dart';

class Week {
  //week index
  int index = 0;
  //schedule list
  List<Schedule> scheduleInfo = [];

  // Convert Week object to JSON
  Map<String, dynamic> toJson() => {
        'index': index,
        'scheduleInfo':
            scheduleInfo.map((schedule) => schedule.toJson()).toList(),
      };

  // Create Week object from JSON
  Week.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    scheduleInfo = (json['scheduleInfo'] as List)
        .map((scheduleJson) => Schedule.fromJson(scheduleJson))
        .toList();
  }

  // Default constructor
  Week();

  void sortSchedulesByStartTime() {
    scheduleInfo.sort((a, b) => a.startTime.compareTo(b.startTime));
  }
}

class Schedule {
  String name = "";
  int startTime = 0;
  int endTime = 0;
  String explanation = "";
  Color btnColor = Colors.white;

  // Convert Schedule object to JSON
  Map<String, dynamic> toJson() => {
        'name': name,
        'startTime': startTime,
        'endTime': endTime,
        'explanation': explanation,
        'btnColor': btnColor.value, // Color를 int로 저장
      };

  // Create Schedule object from JSON
  Schedule.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startTime = json['startTime'];
    endTime = json['endTime'];
    explanation = json['explanation'];
    btnColor = Color(json['btnColor']); // int 값을 Color로 변환
  }

  // Default constructor
  Schedule();
}
