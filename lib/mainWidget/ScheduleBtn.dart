import 'package:flutter/material.dart';

import 'package:weekycal/main.dart';

class ScheduleBtnColumn extends StatefulWidget {
  final int weekIndex;
  const ScheduleBtnColumn({super.key, required this.weekIndex});

  @override
  State<ScheduleBtnColumn> createState() => _ScheduleBtnColumnState();
}

class _ScheduleBtnColumnState extends State<ScheduleBtnColumn> {
  @override
  Widget build(BuildContext context) {
    List<Widget> weekWidgetList = []; // Initialize an empty list of widgets

    if (scheduleData[widget.weekIndex].scheduleInfo.isEmpty) {
      // If there are no schedules, add an empty container
      return SizedBox(
        width: weekContainerSizeX / 7,
      );
    } else {
      // If schedules exist
      double sumHeight = 0.0; // Accumulated height of the widgets
      double minHeightOffset = minTimeMin * weekBtnHightForMin;

      for (int i = 0;
          i < scheduleData[widget.weekIndex].scheduleInfo.length;
          i++) {
        var info = scheduleData[widget.weekIndex].scheduleInfo[i];

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
    Color btnColor = scheduleData[widget.weekIndex]
        .scheduleInfo[widget.scheduleIndex]
        .btnColor;

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
          String name = scheduleData[widget.weekIndex]
              .scheduleInfo[widget.scheduleIndex]
              .name;
          String explanation = scheduleData[widget.weekIndex]
              .scheduleInfo[widget.scheduleIndex]
              .explanation;
          int startTime = scheduleData[widget.weekIndex]
              .scheduleInfo[widget.scheduleIndex]
              .startTime;
          int endTime = scheduleData[widget.weekIndex]
              .scheduleInfo[widget.scheduleIndex]
              .endTime;

          nowWeekIndex = widget.weekIndex;
          nowScheduleIndex = widget.scheduleIndex;

          setState(() {
            // 텍스트 필드의 컨트롤러만 업데이트
            textFieldControllers[0].text = name;
            textFieldControllers[1].text = explanation;
            startTimeNotifier.value =
                TimeOfDay(hour: startTime ~/ 60, minute: startTime % 60);
            endTimeNotifier.value =
                TimeOfDay(hour: endTime ~/ 60, minute: endTime % 60);
            colorButtonColor.value = btnColor;

            isNewSchadule.value = false;
          });
        },
        child: Center(
          child: OverflowBox(
            maxWidth: double.infinity, // 텍스트가 컨테이너를 초과할 수 있도록 함
            child: Text(
              "${scheduleData[widget.weekIndex].scheduleInfo[widget.scheduleIndex].name}", // 텍스트
              style: const TextStyle(
                color: Colors.black,
                fontSize: 10.0,
                overflow: TextOverflow.visible, // 텍스트가 넘칠 수 있도록 설정
              ),
            ),
          ),
        ),
      ),
    );
  }
}
