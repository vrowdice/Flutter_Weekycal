import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:weekycal/main.dart';
import 'package:weekycal/popup.dart';

class ScheduleInfoContainer extends StatelessWidget {
  const ScheduleInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
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
                          fontWeight: FontWeight.bold, fontSize: 20.0),
                      "Schedule Info"),
                ),
                ScheduleControlRow()
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
                    ScheduleInfoTextField(index: 1)
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

// TextField widget for schedule information input
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

    // Set initial value in the TextEditingController
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
              keyboardType: (widget.index == 0 || widget.index == 1)
                  ? TextInputType.number
                  : TextInputType.text,
              inputFormatters: (widget.index == 0 || widget.index == 1)
                  ? [FilteringTextInputFormatter.digitsOnly]
                  : [],
              decoration: const InputDecoration(
                contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                counterText: "",
              ),
              cursorHeight: 15,
              textAlign: TextAlign.left,
              controller: textFieldControllers[widget.index],
              onChanged: (value) {
                setState(() {
                  // Update `nowSchedule`
                  switch (widget.index) {
                    case 0:
                      nowSchedule.name = value;
                      break;
                    case 1:
                      nowSchedule.explanation = value;
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

// TimePicker widget for selecting start and end times
class TimePickerColum extends StatefulWidget {
  const TimePickerColum({super.key});

  @override
  State<TimePickerColum> createState() => _TimePickerColumState();
}

class _TimePickerColumState extends State<TimePickerColum> {
  Color startTimeButtonColor = Colors.blue; // Start time button color
  Color endTimeButtonColor = Colors.green; // End time button color

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Start Time ElevatedButton
        SizedBox(
          width: timeSelectBtnSizeX,
          height: textFieldSizeY,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: startTimeButtonColor, // Button color
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

              nowSchedule.startTime = startTimeNotifier.value.hour * 60 +
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
        ),
        // End Time ElevatedButton
        SizedBox(
          width: timeSelectBtnSizeX,
          height: textFieldSizeY,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: endTimeButtonColor, // Button color
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
                        pickedEndTime.minute <=
                            startTimeNotifier.value.minute)) {
                  showWarningDialog(
                    context,
                    'End Time cannot be earlier than Start Time.',
                  );
                  return;
                }

                nowSchedule.endTime = endTimeNotifier.value.hour * 60 +
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
        ),
        const SizedBox(height: 10), // Spacing
        // Button to choose color (end time button color)
        Row(
          children: [
            const Text("Button Color: "),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: nowSchedule.btnColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(0),
                ),
              ),
              onPressed: () async {
                Color selectedColor = await showColorPickerDialog(context, nowSchedule.btnColor);
                setState(() {
                  nowSchedule.btnColor = selectedColor; // Update the color
                });
                print(nowSchedule.btnColor);
              },
              child: const Text(""),
            ),
          ],
        ),
      ],
    );
  }
}

// Color Picker Dialog
Future<Color> showColorPickerDialog(BuildContext context, Color initialColor) async {
  Color selectedColor = initialColor;
  await showDialog(
    context: context,
    builder: (BuildContext context) {
      return ColorPickerDialog(
        initialColor: selectedColor,
        onColorSelected: (Color color) {
          selectedColor = color;
        },
      );
    },
  );
  return selectedColor;
}

// Color Picker Dialog widget
class ColorPickerDialog extends StatelessWidget {
  final Color initialColor;
  final ValueChanged<Color> onColorSelected;

  const ColorPickerDialog({
    Key? key,
    required this.initialColor,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Pick a color"),
      content: SingleChildScrollView(
        child: ColorPicker(
          pickerColor: initialColor,
          onColorChanged: onColorSelected,
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
  }
}


// Row for restore and delete schedule buttons
class ScheduleControlRow extends StatefulWidget {
  const ScheduleControlRow({super.key});

  @override
  State<ScheduleControlRow> createState() => _ScheduleControlRowState();
}

class _ScheduleControlRowState extends State<ScheduleControlRow> {
  @override
  Widget build(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.end, children: [
      Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: weekContainerSizeX / 3.5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    applyNowSchedule();
                    print("object");
                  });
                },
                child: const Text("Apply"))),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: weekContainerSizeX / 3.5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    deleteNowSchedule();
                  });
                },
                child: const Text("Del"))),
      )
    ]);
  }
}
