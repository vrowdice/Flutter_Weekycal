import 'package:flutter/material.dart';

import 'dataClass.dart';
import 'tools.dart';

import 'mainWidget/weekBtn.dart';
import 'mainWidget/ScheduleBtn.dart';
import 'mainWidget/ScheduleInfoContainer.dart';

//schedule first setting
int week = 7;
int minTime = 6;
int maxTime = 24;
double minTimeMin = 0.0;
double maxTimeMin = 0.0;

//week container size setting


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

//scheduleInfoContanier time select button size
double timeSelectBtnSizeX = 200.0;
double timeSelectBtnSizeY = 45.0;

//now setting schedule
Schedule nowSchedule = Schedule();
int nowWeekIndex = -1;
int nowScheduleIndex = -1;

// sort schedules as start time
void sortSchedulesByStartTime(List<Schedule> schedules) {
  schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
}

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

void applyNowSchedule(){
  if(nowWeekIndex < 0 || nowScheduleIndex < 0){
    return;
  }
  scheduleData[nowWeekIndex].scheduleInfo[nowScheduleIndex] = nowSchedule;
}

void deleteNowSchedule(){
  if(nowWeekIndex < 0 || nowScheduleIndex < 0){
    return;
  }
  scheduleData[nowWeekIndex].scheduleInfo.removeAt(nowScheduleIndex);
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
                              for (int i = 0; i < week; i++)
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
                                for (int i = 0; i < week; i++)
                                  WeekBtnColumn(
                                    week: i,
                                  )
                              ],
                            ),
                            //week schedule check and resetting button columns
                            Row(
                              children: [
                                for (int i = 0; i < week; i++)
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
              const ScheduleInfoContainer()
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
