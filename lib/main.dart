import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:home_widget/home_widget.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;
import 'package:permission_handler/permission_handler.dart';
import 'package:android_intent_plus/android_intent.dart';
import 'package:android_intent_plus/flag.dart';

import 'dataClass.dart';
import 'converter.dart';
import 'saveData.dart';
import 'saveLoad.dart';
import 'option.dart';

import 'package:weekycal/popup.dart';
import 'mainWidget/weekBtn.dart';
import 'mainWidget/ScheduleBtn.dart';
import 'mainWidget/ScheduleInfoContainer.dart';

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

//schedule first setting
int week = 7;
double minTimeMin = 0.0;
double maxTimeMin = 0.0;

//week container size setting
//schedule block size
double weekTimeSizeX = 70.0;
double weekTimeSizeY = 450.0;
double weekContainerSizeX = 290.0;
double weekContainerSizeY = 400.0;
double weekInfoSizeY = 30.0;
double weekBtnHight = 20.0;
double weekBtnHightForMin = 20.0;
double realContainerSizeX = weekContainerSizeX;

//textfield size
double textFieldSizeX = 110;
double textFieldSizeY = 35;

//textfield info
String textfieldName = "";
String textfieldExplanation = "";
String textfieldStartTime = "";
String textfieldEndTime = "";

//this var used in home widget provide id
String dataID = "schedule_data";

//scheduleInfoContanier time select button size
double timeSelectBtnSizeX = 160.0;
double timeSelectBtnSizeY = 70.0;

//now setting schedule
int nowWeekIndex = -1;
int nowScheduleIndex = -1;

// sort schedules as start time
void sortSchedulesByStartTime(List<ScheduleData> schedules) {
  schedules.sort((a, b) => a.startTime.compareTo(b.startTime));
}

//text field controllers
//using info container schadule set textfield
List<TextEditingController> scheduleSetTextFieldControllers = [
  TextEditingController(),
  TextEditingController(),
  // Add controllers for other text fields if necessary
];

//using info container time set textfield
TextEditingController alarmTimeTextFieldControllers =
    TextEditingController(text: '0');
//info container alarm boolen
final ValueNotifier<bool> alarmToggleFlag = ValueNotifier<bool>(false);

//if this flag turn true than sync schadule and turn again to false
final ValueNotifier<bool> isSyncWithSchaduleData = ValueNotifier(false);
//if is new schadule = true
final ValueNotifier<bool> isNewSchedule = ValueNotifier(false);
//time input field controllers
final ValueNotifier<TimeOfDay> startTimeNotifier =
    ValueNotifier(const TimeOfDay(hour: 9, minute: 0));
final ValueNotifier<TimeOfDay> endTimeNotifier =
    ValueNotifier(const TimeOfDay(hour: 10, minute: 0));
// Global variable to manage button color
final ValueNotifier<Color> colorButtonColor =
    ValueNotifier<Color>(Colors.white);

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await loadData();
  initialization();
  tz.initializeTimeZones();

  //home widget activate
  await HomeWidget.getWidgetData<String>(dataID, defaultValue: "None")
      .then((String? value) {});

  AndroidInitializationSettings android =
      const AndroidInitializationSettings("@mipmap/ic_launcher");
  DarwinInitializationSettings ios = const DarwinInitializationSettings(
    requestSoundPermission: false,
    requestBadgePermission: false,
    requestAlertPermission: false,
  );
  InitializationSettings settings =
      InitializationSettings(android: android, iOS: ios);
  await flutterLocalNotificationsPlugin.initialize(settings);

  runApp(const MainApp());
}

Future<void> syncData() async {
  if (isSyncWithSchaduleData.value) {
    return;
  }

  isSyncWithSchaduleData.value = true;

  try {
    // Running the synchronization process
    await Future.delayed(const Duration(milliseconds: 500));
    print("Data sync complete.");
  } catch (e) {
    print("Sync error: $e");
  } finally {
    isSyncWithSchaduleData.value = false;
  }

  await saveData();
}

ScheduleData getNowScheduleData() {
  if (nowWeekIndex < 0 ||
      nowWeekIndex >= scheduleDataList.length ||
      nowScheduleIndex < 0 ||
      nowScheduleIndex >= scheduleDataList[nowWeekIndex].scheduleInfo.length) {
    print("Invalid index");
    return ScheduleData();
  }
  return scheduleDataList[nowWeekIndex].scheduleInfo[nowScheduleIndex];
}

void requestExactAlarmPermission(
    BuildContext context, ScheduleData argScheduelData) async {
  print("Requesting exact alarm permission...");
  final status = await Permission.notification
      .request(); // Requesting notification permission

  if (status.isGranted) {
    showSnackBarPopup("Exact alarm permission granted.");
    requestIgnoreBatteryOptimizations(context);
    setAlarmForSchedule(
        argScheduelData, context); // Set alarm if permission is granted
  } else if (status.isDenied) {
    showSnackBarPopup("Exact alarm permission denied.");
    showPermissionDeniedDialog(context);
  } else if (status.isPermanentlyDenied) {
    showSnackBarPopup("Exact alarm permission permanently denied.");
    showPermissionPermanentlyDeniedDialog(context);
  } else {
    showSnackBarPopup("Exact alarm permission status: $status");
  }
}

void requestIgnoreBatteryOptimizations(BuildContext context) async {
  final intent = AndroidIntent(
    action: 'android.settings.REQUEST_IGNORE_BATTERY_OPTIMIZATIONS',
    data: 'package:com.example.weekycal',
    flags: <int>[Flag.FLAG_ACTIVITY_NEW_TASK],
  );
  await intent.launch();
  showSnackBarPopup(
      "Please disable battery optimizations for proper alarm functionality.");
}

void showSimpleNotification({
  required String title,
  required String body,
  required String payload,
}) async {
  const AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails('channel 1', 'channel 1 name',
          channelDescription: 'channel 1 description',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
  const NotificationDetails notificationDetails =
      NotificationDetails(android: androidNotificationDetails);
  await flutterLocalNotificationsPlugin
      .show(0, title, body, notificationDetails, payload: payload);
}

void setAlarmForSchedule(ScheduleData schedule, BuildContext context) async {
  if (schedule.isAlarm) {
    if (alarmTimeTextFieldControllers.text.isEmpty) {
      showWarningDialog(context, "Please enter the alarm time.");
      return;
    }

    try {
      // Parse the alarm time from the text field
      int alarmTimeInMinutes = int.parse(alarmTimeTextFieldControllers.text);
      DateTime alarmTime = schedule.getAlarmTime(alarmTimeInMinutes);
      print("Scheduled alarm time: $alarmTime");

      // Generate the unique alarm ID
      String alarmId = generateScheduleId(schedule);

      // Notification details
      NotificationDetails details = const NotificationDetails(
        android: AndroidNotificationDetails(
            'schedule channel id', 'schedule notifications',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker'
            // Set PendingIntent flag for Android API 31 and above
            ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

      // Schedule notification with exact time
      try {
        await flutterLocalNotificationsPlugin.zonedSchedule(
          alarmId.hashCode,
          schedule.name,
          schedule.explanation,
          tz.TZDateTime.from(alarmTime, tz.local),
          details,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
        print("Notification successfully scheduled.");
      } catch (e) {
        print("Error occurred while scheduling notification: $e");
      }
    } catch (e) {
      showWarningDialog(context, "Please enter a valid alarm time.");
      print("Error parsing alarm time: $e");
    }
  } else {
    cancelAlarm(schedule); // Handle cancellation if necessary
  }
}

void cancelAlarm(ScheduleData schedule) async {
  String alarmId = generateScheduleId(schedule);
  await flutterLocalNotificationsPlugin.cancel(alarmId.hashCode);
}

void initialization() async {
  minTimeMin = minTime * 60;
  maxTimeMin = maxTimeMin * 60;
  weekBtnHight = ((weekContainerSizeY - weekInfoSizeY) / (maxTime - minTime));
  weekBtnHightForMin = weekBtnHight * (1.0 / 60.0);
  if (isRemoveWeekend) {
    weekContainerSizeX *= 1.5;
    realContainerSizeX /= 1.4;
  }
}

void updateHomeWidget() async {
  String jsonString =
      jsonEncode(scheduleDataList.map((e) => e.toJson()).toList());
  await HomeWidget.saveWidgetData<String>(dataID, jsonString);
  await HomeWidget.updateWidget(name: 'AppWidgetProvider');
}

void applyNowSchedule(BuildContext context) {
  if (nowWeekIndex < 0) {
    return;
  }

  final startTimeInMinutes =
      startTimeNotifier.value.hour * 60 + startTimeNotifier.value.minute;
  final endTimeInMinutes =
      endTimeNotifier.value.hour * 60 + endTimeNotifier.value.minute;

  // Validate start and end time for the same rules as time picker
  if (startTimeNotifier.value.hour < 6 || startTimeNotifier.value.hour >= 24) {
    showWarningDialog(context, 'Start Time must be between 6 AM and 12 AM.');
    return;
  }

  if (endTimeNotifier.value.hour < 6 || endTimeNotifier.value.hour >= 24) {
    showWarningDialog(context, 'End Time must be between 6 AM and 12 AM.');
    return;
  }

  if (endTimeNotifier.value.hour < startTimeNotifier.value.hour ||
      (endTimeNotifier.value.hour == startTimeNotifier.value.hour &&
          endTimeNotifier.value.minute <= startTimeNotifier.value.minute)) {
    showWarningDialog(context, 'End Time cannot be earlier than Start Time.');
    return;
  }

  // Check if the time difference is less than 30 minutes
  final Duration duration = Duration(
    hours: endTimeNotifier.value.hour - startTimeNotifier.value.hour,
    minutes: endTimeNotifier.value.minute - startTimeNotifier.value.minute,
  );

  if (duration.inMinutes < 30) {
    showWarningDialog(
      context,
      'The time difference between Start and End must be at least 30 minutes.',
    );
    return;
  }

  // Function to check if the time overlaps with existing schedules
  bool isTimeOverlap(int scheduleStart, int scheduleEnd) {
    return (scheduleStart < startTimeInMinutes &&
            scheduleEnd > startTimeInMinutes) ||
        (scheduleStart < endTimeInMinutes && scheduleEnd > endTimeInMinutes);
  }

  // Check for time overlaps in the existing schedule data
  for (var schedule in scheduleDataList[nowWeekIndex].scheduleInfo) {
    // Ensure that nowScheduleIndex is valid (not -1) before comparing
    if (nowScheduleIndex >= 0 &&
        schedule ==
            scheduleDataList[nowWeekIndex].scheduleInfo[nowScheduleIndex]) {
      continue;
    }
    if (isTimeOverlap(schedule.startTime, schedule.endTime)) {
      showWarningDialog(
          context, "The time overlaps with an existing schedule.");
      return;
    }
  }

  // Create a new schedule object with the data from the input fields
  ScheduleData nowSchedule = ScheduleData()
    ..name = scheduleSetTextFieldControllers[0].text
    ..explanation = scheduleSetTextFieldControllers[1].text
    ..startTime = startTimeInMinutes
    ..endTime = endTimeInMinutes
    ..btnColor = colorButtonColor.value;

  // Add or update the schedule depending on whether it's a new schedule or not
  if (isNewSchedule.value) {
    // Add the new schedule
    scheduleDataList[nowWeekIndex].scheduleInfo.add(nowSchedule);
    isNewSchedule.value = false;
    nowScheduleIndex = scheduleDataList[nowWeekIndex].scheduleInfo.length - 1;
  } else {
    if (nowScheduleIndex < 0) {
      return;
    }
    // Update the existing schedule
    scheduleDataList[nowWeekIndex].scheduleInfo[nowScheduleIndex] = nowSchedule;
    cancelAlarm(getNowScheduleData());

    isNewSchedule.value = true;
    isNewSchedule.value = false;
  }

  scheduleDataList[nowWeekIndex].sortSchedulesByStartTime();

  // Handle alarm time and isAlarm flag
  try {
    nowSchedule.alarmTime = int.parse(alarmTimeTextFieldControllers.text);
  } catch (e) {
    showWarningDialog(context, "Invalid alarm time input.");
    return;
  }
  nowSchedule.isAlarm = alarmToggleFlag.value;

  if (nowSchedule.isAlarm) {
    requestExactAlarmPermission(context, nowSchedule);
  } else {
    cancelAlarm(getNowScheduleData());
  }

  syncData();
  updateHomeWidget();

  showSnackBarPopup("Schedule has been successfully applied!");
}

void deleteNowSchedule() {
  if (nowWeekIndex < 0 ||
      nowScheduleIndex < 0 ||
      scheduleDataList[nowWeekIndex].scheduleInfo.length <= 0) {
    return;
  }

  cancelAlarm(getNowScheduleData());
  scheduleDataList[nowWeekIndex].scheduleInfo.removeAt(nowScheduleIndex);
  scheduleDataList[nowWeekIndex].sortSchedulesByStartTime();
  isNewSchedule.value = true;

  syncData();

  updateHomeWidget();
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    HomeWidget.widgetClicked.listen((Uri? uri) => loadData());
    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color.fromARGB(255, 10, 10, 10),
        primaryColor: const Color.fromARGB(255, 210, 210, 210),
        colorScheme: const ColorScheme.dark(
          primary: Color.fromARGB(255, 210, 210, 210),
          secondary: Color.fromARGB(255, 210, 210, 210),
          surface: Color.fromARGB(255, 50, 50, 50),
          onPrimary: Colors.black,
          onSecondary: Colors.black,
          onSurface: Colors.white,
        ),
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color.fromARGB(255, 210, 210, 210)),
          bodyMedium: TextStyle(color: Color.fromARGB(255, 210, 210, 210)),
          titleLarge: TextStyle(
              color: Color.fromARGB(255, 210, 210, 210),
              fontWeight: FontWeight.bold),
        ),
      ),
      home: const Scaffold(
        resizeToAvoidBottomInset: true,
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  flex: 1,
                  child: SingleChildScrollView(
                    physics: ClampingScrollPhysics(),
                    child: MainScheduleColumn(),
                  ),
                ),
                ScheduleInfoContainer(),
              ],
            ),
            Positioned(top: 15, left: 15, child: ResetBtn()),
            Positioned(top: 15, left: 60, child: AlarmTmp()),
            Positioned(top: 15, right: 105, child: SaveBtn()),
            Positioned(top: 15, right: 60, child: LoadBtn()),
            Positioned(top: 15, right: 15, child: OptionBtn()),
          ],
        ),
      ),
    );
  }
}

//week text and time text, all schadule info button
class MainScheduleColumn extends StatefulWidget {
  const MainScheduleColumn({super.key});

  @override
  State<MainScheduleColumn> createState() => _MainScheduleColumnState();
}

class _MainScheduleColumnState extends State<MainScheduleColumn> {
  @override
  Widget build(BuildContext context) {
    return Column(
      // Changed to Column to allow for vertical scrolling
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: weekTimeSizeX - 35,
              height: weekContainerSizeY + 30,
              child: Column(
                children: [
                  SizedBox(
                    width: weekTimeSizeX,
                    height: weekInfoSizeY - 5,
                  ),
                  TimeList()
                ],
              ),
            ),
            Container(
              width: realContainerSizeX + 2,
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
                      Row(
                        children: [
                          for (int i = 0; i < week; i++)
                            WeekBtnColumn(
                              index: i,
                            )
                        ],
                      ),
                      ValueListenableBuilder(
                        valueListenable: isSyncWithSchaduleData,
                        builder: (context, isSyncWithData, child) {
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              for (int i = 0; i < week; i++)
                                ScheduleBtnColumn(
                                  weekIndex: i,
                                )
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class TimeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int timeCount = maxTime - minTime + 1;
    double itemHeight = 15;

    return SizedBox(
      height: weekContainerSizeY - 18,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(timeCount, (index) {
          return SizedBox(
            height: itemHeight,
            child: Align(
              alignment: Alignment.topLeft,
              child: Text(
                '${minTime + index}:00',
                style: const TextStyle(fontSize: 12.0),
              ),
            ),
          );
        }),
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
    if (isRemoveWeekend) {
      if (index == 0 || index >= week - 1) {
        return const SizedBox();
      }
    }
    return Container(
      alignment: Alignment.center,
      width: weekContainerSizeX / 7,
      height: weekInfoSizeY,
      decoration: BoxDecoration(
        color: Colors.black,
        border: Border.all(width: 2.0),
      ),
      child: Text(
        convertWeekIntToStr(index),
        style: const TextStyle(fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    );
  }
}
