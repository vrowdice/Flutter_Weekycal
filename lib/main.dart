import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'dataClass.dart';
import 'tools.dart';
import 'popup.dart';

//import 'package:flutter/widgets.dart';

//week container size setting
int minTime = 6;
int maxTime = 24;
double minTimeMin = 0.0;
double maxTimeMin = 0.0;

//schedule block size
double weekTimeSizeX = 100.0;
double weekTimeSizeY = 450.0;
double weekContainerSizeX = 450.0;
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

//text field controllers
List<TextEditingController> textFieldControllers =
    List.generate(2, (index) => TextEditingController());
//time input field controllers
final ValueNotifier<TimeOfDay> startTimeNotifier =
    ValueNotifier(TimeOfDay(hour: 9, minute: 0));
final ValueNotifier<TimeOfDay> endTimeNotifier =
    ValueNotifier(TimeOfDay(hour: 10, minute: 0));

//week data array
var scheduleData = List.generate(7, (index) {
  Week week = Week();
  week.index = index;
  return week;
});

//now setting schedule
Schedule nowTimeSchedule = Schedule();
int nowWeekIndex = 0;
int nowScheduleIndex = 0;

// sort schedules as start time
void sortSchedulesByStartTime(List<Schedule> schedules) {
  schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
}

void main() {
  //sample schedule
  Schedule sampleSchedule1 = Schedule();
  sampleSchedule1.index = 0;
  sampleSchedule1.name = "new schedule0";
  sampleSchedule1.startTime = 600;
  sampleSchedule1.endTime = 720;
  sampleSchedule1.explanation = "exp0";

  scheduleData[2].scheduleInfo.add(sampleSchedule1);

  Schedule sampleSchedule2 = Schedule();
  sampleSchedule2.index = 1;
  sampleSchedule2.name = "new schedule1";
  sampleSchedule2.startTime = 780;
  sampleSchedule2.endTime = 900;
  sampleSchedule2.explanation = "exp1";

  scheduleData[2].scheduleInfo.add(sampleSchedule2);

  Schedule sampleSchedule3 = Schedule();
  sampleSchedule3.index = 2;
  sampleSchedule3.name = "new schedule2";
  sampleSchedule3.startTime = 900;
  sampleSchedule3.endTime = 1080;
  sampleSchedule3.explanation = "exp2";

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
                                    weekIndex: i,
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
                  height: weekContainerSizeY / 2.3,
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
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5.0),
                            child: Text(
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                                "Schedule Info"),
                          ),
                          scheduleControlRow()
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.all(5),
                            child: TimePickerColum(),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ScheduleInfoTextField(index: 0),
                              SizedBox(
                                width: 25,
                              ),
                              ScheduleInfoTextField(index: 1)
                            ],
                          ),
                        ],
                      ),
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
      child: Text(convertWeekIntToStr(index)),
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
      weekWidgetList.add(Container(width: weekContainerSizeX / 7));
    } else {
      // If schedules exist
      double sumHeight = 0.0; // Accumulated height of the widgets
      double minHeightOffset = minTimeMin * weekBtnHightForMin;

      for (var info in scheduleData[widget.weekIndex].scheduleInfo) {
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

        // Add the schedule button
        weekWidgetList.add(ScheduleBtn(
            weekIndex: widget.weekIndex,
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
  final int weekIndex;
  final int scheduleIndex;
  final double height;
  const ScheduleBtn(
      {super.key,
      required this.weekIndex,
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
      decoration:
          BoxDecoration(color: Colors.white, border: Border.all(width: 0.5)),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
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

          nowTimeSchedule.name = name;
          nowTimeSchedule.explanation = explanation;
          nowTimeSchedule.startTime = startTime;
          nowTimeSchedule.endTime = endTime;

          setState(() {
            // 텍스트 필드의 컨트롤러만 업데이트
            textFieldControllers[0].text = name;
            textFieldControllers[1].text = explanation;
            startTimeNotifier.value =
                TimeOfDay(hour: startTime ~/ 60, minute: startTime % 60);
            endTimeNotifier.value =
                TimeOfDay(hour: endTime ~/ 60, minute: endTime % 60);
          });

          nowWeekIndex = widget.weekIndex;
          nowScheduleIndex = widget.scheduleIndex;
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

class ScheduleInfoTextField extends StatefulWidget {
  final int index;

  const ScheduleInfoTextField({super.key, required this.index});

  @override
  State<ScheduleInfoTextField> createState() => _ScheduleInfoTextFieldState();
}

class _ScheduleInfoTextFieldState extends State<ScheduleInfoTextField> {
  @override
  Widget build(BuildContext context) {
    String label = "";
    String initialValue = "";

    // 각 필드에 해당하는 레이블과 초기값 설정
    switch (widget.index) {
      case 0:
        label = "Name";
        break;
      case 1:
        label = "Explanation";
        break;
      default:
        label = "";
        initialValue = "";
    }

    // 전역 리스트에서 해당 index의 TextEditingController를 사용
    textFieldControllers[widget.index].text = initialValue;

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: textFieldSizeX,
            height: textFieldSizeY,
            child: TextField(
              maxLength: 12,
              keyboardType: (widget.index == 1 || widget.index == 3)
                  ? TextInputType.number // 숫자 입력
                  : TextInputType.text, // 텍스트 입력
              inputFormatters: (widget.index == 1 || widget.index == 3)
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [], // 숫자 필드만 숫자 제한
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                counterText: "", // 글자수 표시 제거
              ),
              cursorHeight: 20,
              textAlign: TextAlign.left,
              controller:
                  textFieldControllers[widget.index], // 전역 텍스트 필드 컨트롤러 사용
              onChanged: (value) {
                setState(() {
                  // `nowSchedule` 업데이트
                  switch (widget.index) {
                    case 0:
                      nowTimeSchedule.name = value;
                      break;
                    case 1:
                      nowTimeSchedule.explanation = value;
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

class TimePickerColum extends StatefulWidget {
  const TimePickerColum({super.key});

  @override
  State<TimePickerColum> createState() => _TimePickerColumState();
}

class _TimePickerColumState extends State<TimePickerColum> {
  Color startTimeButtonColor = Colors.blue; // 시작 시간 버튼 색
  Color endTimeButtonColor = Colors.green; // 종료 시간 버튼 색

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // 시작 시간 ElevatedButton
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: startTimeButtonColor, // 색 설정
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () async {
            TimeOfDay? pickedStartTime = await showTimePicker(
              context: context,
              initialTime: startTimeNotifier.value,
            );

            if (pickedStartTime != null &&
                pickedStartTime != startTimeNotifier.value) {
              if (pickedStartTime.hour < 6 || pickedStartTime.hour >= 24) {
                showWarningDialog(
                  context,
                  'Please select a time between 6 AM and 12 AM.',
                );
                return;
              }

              startTimeNotifier.value = pickedStartTime;
            }

            nowTimeSchedule.startTime = startTimeNotifier.value.hour * 60 +
                startTimeNotifier.value.minute;
          },
          child: ValueListenableBuilder<TimeOfDay>(
            valueListenable: startTimeNotifier,
            builder: (context, startTime, _) {
              return Text(
                'Start Time: ${startTime.format(context)}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              );
            },
          ),
        ),
        // 종료 시간 ElevatedButton
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: endTimeButtonColor, // 색 설정
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          onPressed: () async {
            TimeOfDay? pickedEndTime = await showTimePicker(
              context: context,
              initialTime: endTimeNotifier.value,
            );

            if (pickedEndTime != null &&
                pickedEndTime != endTimeNotifier.value) {
              if (pickedEndTime.hour < 6 || pickedEndTime.hour >= 24) {
                showWarningDialog(
                  context,
                  'Please select a time between 6 AM and 12 AM.',
                );
                return;
              }

              if (pickedEndTime.hour < startTimeNotifier.value.hour ||
                  (pickedEndTime.hour == startTimeNotifier.value.hour &&
                      pickedEndTime.minute <= startTimeNotifier.value.minute)) {
                showWarningDialog(
                  context,
                  'End Time cannot be earlier than Start Time.',
                );
                return;
              }

              nowTimeSchedule.endTime = endTimeNotifier.value.hour * 60 +
                  endTimeNotifier.value.minute;
              endTimeNotifier.value = pickedEndTime;
            }
          },
          child: ValueListenableBuilder<TimeOfDay>(
            valueListenable: endTimeNotifier,
            builder: (context, endTime, _) {
              return Text(
                'End Time: ${endTime.format(context)}',
                style: const TextStyle(color: Colors.white, fontSize: 13),
              );
            },
          ),
        ),
        const SizedBox(height: 10), // 간격
        // 색 선택 버튼 (종료 시간 버튼 색)
        ElevatedButton(
          onPressed: () {
            showColorPicker(context, false);
          },
          child: const Text("Choose Button Color"),
        ),
      ],
    );
  }

  // 색 선택기 호출 함수
  void showColorPicker(BuildContext context, bool isStartTime) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Pick a color"),
          content: SingleChildScrollView(
            child: ColorPicker(
              pickerColor: isStartTime ? startTimeButtonColor : endTimeButtonColor,
              onColorChanged: (Color color) {
                setState(() {
                  if (isStartTime) {
                    startTimeButtonColor = color;
                  } else {
                    endTimeButtonColor = color;
                  }
                });
              },
              showLabel: true,
              pickerAreaHeightPercent: 0.8,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text("OK"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
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
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
            width: weekContainerSizeX / 3.5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Apply"))),
      ),
      Padding(
        padding: EdgeInsets.all(5),
        child: SizedBox(
            width: weekContainerSizeX / 3.5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                child: const Text("Del"))),
      )
    ]);
  }
}
