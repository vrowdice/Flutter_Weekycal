import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dataClass.dart';
//import 'package:flutter/widgets.dart';

//week container size setting
int minTime = 6;
int maxTime = 24;
double minTimeMin = 0.0;
double maxTimeMin = 0.0;

//schedule block size
double weekTimeSizeX = 100.0;
double weekTimeSizeY = 450.0;
double weekContainerSizeX = 400.0;
double weekContainerSizeY = 400.0;
double weekInfoSizeY = 30.0;
double weekBtnHight = 0.0;
double weekBtnHightForMin = 0.0;

//textfield size
double textFieldSizeX = 120;
double textFieldSizeY = 25;
//textfield info
String textfieldName = "";
String textfieldExplanation = "";
String textfieldStartTime = "";
String textfieldEndTime = "";

//week data array
var scheduleData = List.generate(7, (index) {
  Week week = Week();
  week.index = index;
  return week;
});

Schedule nowSchedule = new Schedule();

void main() {
  //sample schedule
  Schedule sampleSchedule1 = Schedule();
  sampleSchedule1.index = 0;
  sampleSchedule1.name = "new schedule";
  sampleSchedule1.startTime = 600;
  sampleSchedule1.endTime = 720;
  sampleSchedule1.explanation = "exp";

  scheduleData[2].scheduleInfo.add(sampleSchedule1);

  Schedule sampleSchedule2 = Schedule();
  sampleSchedule2.index = 1;
  sampleSchedule2.name = "new schedule";
  sampleSchedule2.startTime = 780;
  sampleSchedule2.endTime = 900;
  sampleSchedule2.explanation = "exp";

  scheduleData[2].scheduleInfo.add(sampleSchedule2);

  Schedule sampleSchedule3 = Schedule();
  sampleSchedule3.index = 2;
  sampleSchedule3.name = "new schedule";
  sampleSchedule3.startTime = 900;
  sampleSchedule3.endTime = 1080;
  sampleSchedule3.explanation = "exp";

  scheduleData[2].scheduleInfo.add(sampleSchedule3);

  minTimeMin = minTime * 60;
  maxTimeMin = maxTimeMin * 60;
  weekBtnHight = ((weekContainerSizeY - weekInfoSizeY) / (maxTime - minTime));
  weekBtnHightForMin = weekBtnHight * (1.0 / 60.0);

  runApp(const MainApp());
}

//main
class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
          resizeToAvoidBottomInset: false,
          bottomNavigationBar: BottomNavigationBar(
            onTap: (int index) {
              switch (index) {
                case 0:
                  break;
                case 1:
                  break;
                default:
              }
            },
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.schedule), label: 'Schedule'),
              BottomNavigationBarItem(
                  icon: Icon(Icons.settings), label: 'Setting')
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //set time text
                  SizedBox(
                    width: weekTimeSizeX - 50,
                    height: weekContainerSizeY + 20,
                    child: Column(
                      children: [
                        SizedBox(
                          width: weekTimeSizeX,
                          height: weekInfoSizeY - 10,
                        ),
                        for (int i = minTime; i < maxTime + 1; i++)
                          TimeText(index: i)
                      ],
                    ),
                  ),
                  //set schedule block
                  Container(
                    width: weekContainerSizeX + 2,
                    height: weekContainerSizeY + 2,
                    decoration: BoxDecoration(border: Border.all(width: 1.0)),
                    child: Column(
                      children: [
                        Center(
                          child: Row(
                            children: [
                              for (int i = 0; i < 7; i++)
                                WeekStateBlock(
                                  index: i,
                                )
                            ],
                          ),
                        ),
                        Stack(
                          children: [
                            //week setting button columns
                            Row(
                              children: [
                                for (int i = 0; i < 7; i++)
                                  WeekBtnColumn(
                                    week: i,
                                  )
                              ],
                            ),
                            //week schedule check and resetting button columns
                            Row(
                              children: [
                                for (int i = 0; i < 7; i++)
                                  ScheduleBtnColumn(
                                    week: i,
                                  )
                              ],
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
              //set schedule info block
              Container(
                  width: weekContainerSizeX + 50,
                  height: weekContainerSizeY / 2.5,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 247, 242, 249),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Text(
                            style: TextStyle(fontWeight: FontWeight.bold),
                            "Schedule Info"),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            children: [
                              ScheduleInfoTextField(index: 0),
                              ScheduleInfoTextField(index: 1)
                            ],
                          ),
                          Column(
                            children: [
                              ScheduleInfoTextField(index: 2),
                              ScheduleInfoTextField(index: 3)
                            ],
                          )
                        ],
                      ),
                      scheduleControlRow()
                    ],
                  ))
            ],
          )),
    );
  }
}

//time text ui
class TimeText extends StatelessWidget {
  final int index;
  const TimeText({super.key, required, required this.index});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: (weekContainerSizeY - 41) / (maxTime - minTime) + 0.6,
      child: Text(
        '${index.toString()} : 00',
      ),
    );
  }
}

//show week state block
//no any function without show week
class WeekStateBlock extends StatelessWidget {
  final int index;
  const WeekStateBlock({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Text(convertWeekIntToStr(index)),
      ),
      width: weekContainerSizeX / 7,
      height: weekInfoSizeY,
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 1.0)),
    );
  }
}

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
            week: week,
            time: i,
          )
      ],
    );
  }
}

//week setting, info button
class WeekBtn extends StatefulWidget {
  final int week;
  final int time;
  const WeekBtn({super.key, required this.week, required this.time});

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
            onPressed: () {},
            child: Container()));
  }
}

class ScheduleBtnColumn extends StatefulWidget {
  final int week;
  const ScheduleBtnColumn({super.key, required this.week});

  @override
  State<ScheduleBtnColumn> createState() => _ScheduleBtnColumnState();
}

class _ScheduleBtnColumnState extends State<ScheduleBtnColumn> {
  @override
  Widget build(BuildContext context) {
    List<Widget> weekWidgetList = []; // Initialize an empty list of widgets

    if (scheduleData[widget.week].scheduleInfo.isEmpty) {
      // If there are no schedules, add an empty container
      weekWidgetList.add(Container(width: weekContainerSizeX / 7));
    } else {
      // If schedules exist
      double sumHeight = 0.0; // Accumulated height of the widgets
      double minHeightOffset = minTimeMin * weekBtnHightForMin;

      for (var info in scheduleData[widget.week].scheduleInfo) {
        // Calculate the height for the empty space
        double emptyBoxHeight =
            info.startTime * weekBtnHightForMin - minHeightOffset - sumHeight;
        // Calculate the height of the schedule button
        double scheduleBtnHeight =
            weekBtnHightForMin * (info.endTime - info.startTime);

        // Add empty space if its height is greater than 0
        if (emptyBoxHeight > 0) {
          weekWidgetList.add(SizedBox(height: emptyBoxHeight));
        }

        print(info.index);

        // Add the schedule button
        weekWidgetList.add(ScheduleBtn(
            week: widget.week,
            scheduleIndex: info.index,
            height: scheduleBtnHeight));
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
  final int week;
  final int scheduleIndex;
  final double height;
  const ScheduleBtn(
      {super.key,
      required this.week,
      required this.scheduleIndex,
      required this.height});

  @override
  State<ScheduleBtn> createState() => _ScheduleBtnState();
}

class _ScheduleBtnState extends State<ScheduleBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: weekContainerSizeX / 7,
      height: widget.height,
      decoration: BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
        ),
        onPressed: () {
          setState(() {
            // Ensure that nowSchedule is a mutable state and changes trigger UI update
            nowSchedule.name = scheduleData[widget.week]
                .scheduleInfo[widget.scheduleIndex]
                .name;
            nowSchedule.explanation = scheduleData[widget.week]
                .scheduleInfo[widget.scheduleIndex]
                .explanation;
            nowSchedule.startTime = scheduleData[widget.week]
                .scheduleInfo[widget.scheduleIndex]
                .startTime;
            nowSchedule.endTime = scheduleData[widget.week]
                .scheduleInfo[widget.scheduleIndex]
                .endTime;
          });

          // Debugging: Print the updated nowSchedule
          print("Updated nowSchedule: ${nowSchedule.name}, ${nowSchedule.startTime}, ${nowSchedule.endTime}");
        },
        child: Center(
          child: Text(
            "${nowSchedule.name}", // This will help visualize the button's clickable content
            style: TextStyle(color: Colors.black, fontSize: 10.0),
          ),
        ),
      ),
    );
  }
}


class ScheduleInfoTextField extends StatefulWidget {
  final int index;
  const ScheduleInfoTextField({super.key, required this.index});

  @override
  State<ScheduleInfoTextField> createState() => _ScheduleInfoTextFieldState();
}

class _ScheduleInfoTextFieldState extends State<ScheduleInfoTextField> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(ScheduleInfoTextField oldWidget) {
    super.didUpdateWidget(oldWidget);
    // nowSchedule이 변경될 때마다 컨트롤러를 갱신
    _initializeController();
  }

  void _initializeController() {
    // nowSchedule의 값에 맞춰 컨트롤러 초기화
    switch (widget.index) {
      case 0:
        _controller = TextEditingController(text: nowSchedule.name);
        break;
      case 1:
        _controller = TextEditingController(text: nowSchedule.startTime.toString());
        break;
      case 2:
        _controller = TextEditingController(text: nowSchedule.explanation);
        break;
      case 3:
        _controller = TextEditingController(text: nowSchedule.endTime.toString());
        break;
      default:
        _controller = TextEditingController();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String label = "";
    switch (widget.index) {
      case 0:
        label = "Name";
        break;
      case 1:
        label = "Start Time";
        break;
      case 2:
        label = "Explanation";
        break;
      case 3:
        label = "End Time";
        break;
      default:
        label = "";
    }

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              style: const TextStyle(fontSize: 12),
              textAlign: TextAlign.center,
              label,
            ),
          ),
          SizedBox(
            width: textFieldSizeX,
            height: textFieldSizeY,
            child: TextField(
              controller: _controller, // TextEditingController 연결
              maxLength: 12,
              keyboardType: (widget.index == 1 || widget.index == 3)
                  ? TextInputType.number // Allow number input only for startTime and endTime
                  : TextInputType.text, // Default for name and explanation
              inputFormatters: (widget.index == 1 || widget.index == 3)
                  ? [
                      FilteringTextInputFormatter.digitsOnly
                    ] // Only digits allowed
                  : [], // No restrictions for other fields
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                counterText: "", // Disable the character count display
              ),
              cursorHeight: 20,
              textAlign: TextAlign.left,
              onChanged: (value) {
                setState(() {
                  switch (widget.index) {
                    case 0: // name should be a string
                      nowSchedule.name = value;
                      break;
                    case 1: // startTime should be an integer
                      nowSchedule.startTime = int.tryParse(value) ?? 0;
                      break;
                    case 2: // explanation should be a string
                      nowSchedule.explanation = value;
                      break;
                    case 3: // endTime should be an integer
                      nowSchedule.endTime = int.tryParse(value) ?? 0;
                      break;
                    default:
                      break;
                  }
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}


class scheduleControlRow extends StatefulWidget {
  const scheduleControlRow({super.key});

  @override
  State<scheduleControlRow> createState() => _scheduleControlRowState();
}

class _scheduleControlRowState extends State<scheduleControlRow> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      SizedBox(
          width: weekContainerSizeX / 2.5,
          height: weekContainerSizeY / 11,
          child: ElevatedButton(
              onPressed: () {
                setState(() {});
              },
              child: const Text("Apply, Del")))
    ]);
  }
}

//month string to month index
String convertWeekIntToStr(int argIndex) {
  switch (argIndex) {
    case 0:
      return 'Sun';
    case 1:
      return 'Mon';
    case 2:
      return 'Tue';
    case 3:
      return 'Wed';
    case 4:
      return 'Thu';
    case 5:
      return 'Fri';
    case 6:
      return 'Sat';
    default:
      return '';
  }
}
