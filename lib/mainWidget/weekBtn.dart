import 'package:flutter/material.dart';

import 'package:weekycal/main.dart';

//one week button column
class WeekBtnColumn extends StatelessWidget {
  final int week;
  const WeekBtnColumn({super.key, required this.week});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (int i = minTime; i < maxTime; i++)
          WeekBtn(
            weekIndex: week,
            time: i,
          )
      ],
    );
  }
}

//week setting, info button
class WeekBtn extends StatefulWidget {
  final int weekIndex;
  final int time;
  const WeekBtn({super.key, required this.weekIndex, required this.time});

  @override
  State<WeekBtn> createState() => WeekBtnState();
}

//weekly calendar button in schedule settings
class WeekBtnState extends State<WeekBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: weekContainerSizeX / 7,
        height: weekBtnHight,
        decoration:
            BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0))),
            onPressed: () {
              setState(() {
                startTimeNotifier.value =
                    TimeOfDay(hour: widget.time, minute: 0);
                endTimeNotifier.value =
                    TimeOfDay(hour: widget.time + 1, minute: 0);
              });
            },
            child: Container()));
  }
}