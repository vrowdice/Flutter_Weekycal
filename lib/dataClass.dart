import 'package:flutter/material.dart';

class Week {
  //week index
  int index = 0;
  //schedule list
  List<Schedule> scheduleInfo = [];
}

class Schedule {
  //schedule index
  int index = -1;
  //schedule name
  String name = "";
  //schedule start time
  int startTime = 0;
  //schedule end time
  int endTime = 0;
  //schedule explanation
  String explanation = "";
  //button color
  Color btnColor = Colors.white;
}