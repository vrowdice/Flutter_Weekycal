import 'package:flutter/material.dart';

import 'package:weekycal/main.dart';
import 'package:weekycal/saveData.dart';

class ScheduleBtnColumn extends StatefulWidget {
  final int weekIndex;
  const ScheduleBtnColumn({super.key, required this.weekIndex});

  @override
  State<ScheduleBtnColumn> createState() => _ScheduleBtnColumnState();
}

class _ScheduleBtnColumnState extends State<ScheduleBtnColumn> {
  @override
  Widget build(BuildContext context) {
    if (isRemoveWeekend) {
      if (widget.weekIndex == 0 || widget.weekIndex >= week - 1) {
        return const SizedBox();
      }
    }
    List<Widget> weekWidgetList = []; // Initialize an empty list of widgets

    if (scheduleDataList[widget.weekIndex].scheduleInfo.isEmpty) {
      // If there are no schedules, add an empty container
      return SizedBox(
        width: weekContainerSizeX / 7,
      );
    } else {
      // If schedules exist
      double sumHeight = 0.0; // Accumulated height of the widgets
      double minHeightOffset = minTimeMin * weekBtnHightForMin;

      for (int i = 0;
          i < scheduleDataList[widget.weekIndex].scheduleInfo.length;
          i++) {
        var info = scheduleDataList[widget.weekIndex].scheduleInfo[i];

        if (info.startTime / 60 < minTime || info.endTime / 60 > maxTime) {
          continue;
        }

        // Calculate the height for the empty space
        double emptyBoxHeight =
            info.startTime * weekBtnHightForMin - minHeightOffset - sumHeight;
        // Calculate the height of the schedule button
        double scheduleBtnHeight =
            weekBtnHightForMin * (info.endTime - info.startTime);

        // Add empty space if its height is greater than 0
        if (emptyBoxHeight > 0) {
          weekWidgetList.add(SizedBox(
            height: emptyBoxHeight,
          ));
        }

        // Add the schedule button
        weekWidgetList.add(ScheduleBtn(
          weekIndex: widget.weekIndex,
          scheduleIndex: i, // Use the index here as well
          height: scheduleBtnHeight,
        ));
        sumHeight +=
            emptyBoxHeight + scheduleBtnHeight; // Update the accumulated height
      }
    }

    // Return the final widget list wrapped in a Column
    return Column(
      children: weekWidgetList,
    );
  }
}

class ScheduleBtn extends StatefulWidget {
  final int weekIndex;
  final int scheduleIndex;
  final double height;
  const ScheduleBtn({
    super.key,
    required this.weekIndex,
    required this.scheduleIndex,
    required this.height,
  });

  @override
  State<ScheduleBtn> createState() => _ScheduleBtnState();
}

class _ScheduleBtnState extends State<ScheduleBtn> {
  @override
  Widget build(BuildContext context) {
    // Extracting the schedule data for easier access
    var schedule =
        scheduleDataList[widget.weekIndex].scheduleInfo[widget.scheduleIndex];
    Color btnColor = schedule.btnColor;
    bool explanationVisible = (schedule.endTime - schedule.startTime) >= 120;

    return Container(
      width: weekContainerSizeX / 7,
      height: widget.height,
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: btnColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          nowWeekIndex = widget.weekIndex;
          nowScheduleIndex = widget.scheduleIndex;

          setState(() {
            // Updating text field controllers
            scheduleSetTextFieldControllers[0].text = schedule.name;
            scheduleSetTextFieldControllers[1].text = schedule.explanation;
            alarmTimeTextFieldControllers.text = schedule.alarmTime.toString(); // Handle null alarmTime
            alarmToggleFlag.value = schedule.isAlarm;
            startTimeNotifier.value = TimeOfDay(
                hour: schedule.startTime ~/ 60,
                minute: schedule.startTime % 60);
            endTimeNotifier.value = TimeOfDay(
                hour: schedule.endTime ~/ 60, minute: schedule.endTime % 60);
            colorButtonColor.value = btnColor;
            
            isNewSchedule.value = true; //valueNotifier active
            isNewSchedule.value = false;
          });
        },
        child: OverflowBox(
          maxWidth: double.infinity, // Allowing text to overflow if necessary
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                schedule.name, // Schedule name
                style: const TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 10.0,
                  overflow:
                      TextOverflow.visible, // Allow text to overflow if needed
                ),
              ),
              Visibility(
                visible: explanationVisible,
                child: Text(
                  schedule.explanation, // Schedule explanation
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 10.0,
                    overflow: TextOverflow.visible,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}