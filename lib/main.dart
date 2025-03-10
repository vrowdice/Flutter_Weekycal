import 'package:flutter/material.dart';
//import 'package:flutter/widgets.dart';

//week container size setting
int minTime = 6;
int maxTime = 24;

//schedule block size
double weekTimeSizeX = 100.0;
double weekTimeSizeY = 450.0;
double weekContainerSizeX = 400.0;
double weekContainerSizeY = 400.0;
double weekInfoSizeY = 30.0;

//textfield size
double textFieldSizeX = 120;
double textFieldSizeY = 25;
//textfield info
String textfieldName = "";
String textfieldExplanation = "";
String textfieldStartTime = "";
String textfieldEndTime = "";

//week data array
var schedule = List.generate(7, (index) {
  Week week = Week();
  week.index = index;
  return week;
});

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
}

void main() {
  //sample schedule
  Schedule sampleSchedule = Schedule();
  sampleSchedule.name = "new schedule";
  sampleSchedule.startTime = 600;
  sampleSchedule.endTime = 720;
  sampleSchedule.explanation = "exp";

  schedule[2].scheduleInfo.add(sampleSchedule);

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
                  height: weekContainerSizeY / 3,
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
        height: ((weekContainerSizeY - weekInfoSizeY) / (maxTime - minTime)),
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
    List<Widget> weekWidgetList = []; // 초기화 시 List<Widget> 사용
    List<int> scheduleInfoList = [];
    List<int> scheduleStartTimeList = [];
    List<int> scheduleEndTimeList = [];
    List<int> btnOrder = [];

    // 일정 정보 추출
    for (int i = 0; i < schedule[widget.week].scheduleInfo.length; i++) {
      scheduleInfoList.add(schedule[widget.week].scheduleInfo[i].index);
      scheduleStartTimeList
          .add(schedule[widget.week].scheduleInfo[i].startTime);
      scheduleEndTimeList.add(schedule[widget.week].scheduleInfo[i].endTime);
    }

    //중간중간에 유동적으로 맞는 컨테이너를 삽입해야 함
    //1시 30분 1시 40분 등 1시간 단위 처리가 아닌 분 단위 처리를 위해
    


    if (schedule[widget.week].scheduleInfo.length <= 0) {
      weekWidgetList.add(Container(width: weekContainerSizeX / 7));
    } else {
      btnOrder = List.filled(maxTime - minTime, -1);
      for (int i = 0; i < scheduleStartTimeList.length; i++) {

      }
      for (int i = 0; i < maxTime - minTime; i++) {}
    }

    return Column(
      children: weekWidgetList, // 최종적으로 구성된 위젯 리스트 반환
    );
  }
}

class ScheduleBtn extends StatefulWidget {
  final int week;
  final int index;
  const ScheduleBtn({super.key, required this.week, required this.index});

  @override
  State<ScheduleBtn> createState() => _ScheduleBtnState();
}

class _ScheduleBtnState extends State<ScheduleBtn> {
  @override
  Widget build(BuildContext context) {
    return Container(
        width: weekContainerSizeX / 7,
        height: (((weekContainerSizeY - weekInfoSizeY) / (maxTime - minTime)) *
            (schedule[widget.week].scheduleInfo[widget.index].endTime / 60 -
                schedule[widget.week].scheduleInfo[widget.index].startTime /
                    60)),
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

class ScheduleInfoTextField extends StatefulWidget {
  final int index;
  const ScheduleInfoTextField({super.key, required this.index});

  @override
  State<ScheduleInfoTextField> createState() => _ScheduleInfoTextFieldState();
}

class _ScheduleInfoTextFieldState extends State<ScheduleInfoTextField> {
  @override
  Widget build(BuildContext context) {
    String text = "";
    switch (widget.index) {
      case 0:
        text = "Name";
      case 1:
        text = "Start Time";
      case 2:
        text = "Explanation";
      case 3:
        text = "End Time";
      default:
        text = "";
    }

    return Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          children: [
            SizedBox(
              width: 70,
              child: Text(
                  style: const TextStyle(fontSize: 12),
                  textAlign: TextAlign.center,
                  text),
            ),
            SizedBox(
              width: textFieldSizeX,
              height: textFieldSizeY,
              child: TextField(
                maxLength: 12,
                decoration: const InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                ),
                cursorHeight: 20,
                textAlign: TextAlign.left,
                onChanged: (value) {
                  setState(() {
                    switch (widget.index) {
                      case 0:
                        textfieldName = value;
                      case 1:
                        textfieldStartTime = value;
                      case 2:
                        textfieldExplanation = value;
                      case 3:
                        textfieldEndTime = value;
                      default:
                        text = "";
                    }
                  });
                },
              ),
            ),
          ],
        ));
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
