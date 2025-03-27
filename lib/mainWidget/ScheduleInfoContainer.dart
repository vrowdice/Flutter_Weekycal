import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'package:weekycal/main.dart';
import 'package:weekycal/popup.dart';
import 'package:weekycal/saveData.dart';

class ScheduleInfoContainer extends StatelessWidget {
  const ScheduleInfoContainer({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        width: realContainerSizeX + 65,
        height: weekContainerSizeY / 2,
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 43, 43, 43),
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(1, 1),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ContainerTitleText(
                        isNewScheduleNotifier: isNewSchedule)),
                const ScheduleControlRow()
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: 160,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 32, 32, 32),
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 5,
                          offset: Offset(1, 1),
                        ),
                      ],
                    ),
                    child: const TimePickerColum(),
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ScheduleInfoTextField(index: 0),
                    ScheduleInfoTextField(index: 1),
                    AlarmToggle()
                  ],
                ),
              ],
            ),
          ],
        ));
  }
}

class ContainerTitleText extends StatefulWidget {
  final ValueNotifier<bool> isNewScheduleNotifier;
  const ContainerTitleText({super.key, required this.isNewScheduleNotifier});

  @override
  State<ContainerTitleText> createState() => _ContainerTitleTextState();
}

class _ContainerTitleTextState extends State<ContainerTitleText> {
  String _getScheduleInfo() {
    if (widget.isNewScheduleNotifier.value) return 'New Schedule Info';

    if (nowWeekIndex < 0) {
      return 'No Schedule Data';
    } else {
      print(nowScheduleIndex.toString() + " " + nowWeekIndex.toString());
      return scheduleDataList[nowWeekIndex].scheduleInfo[nowScheduleIndex].name;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isNewScheduleNotifier,
      builder: (context, isNewSchedule, child) {
        return SizedBox(
          width: 170,
          child: Column(
            children: [
              if (isNewSchedule) ...[
                const SizedBox(height: 20),
                const Text(
                  "New Schedule Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ] else ...[
                Text(_getScheduleInfo()),
                const Text(
                  "Schedule Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18.0,
                  ),
                ),
              ],
            ],
          ),
        );
      },
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

    switch (widget.index) {
      case 0:
        label = "Name";
        break;
      case 1:
        label = "Explan";
        break;
      default:
        label = "";
    }

    // textFieldControllers controller will be used
    TextEditingController controller =
        scheduleSetTextFieldControllers[widget.index];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 120,
            height: 25,
            child: TextField(
              maxLength: 13,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                counterText: "",
              ),
              cursorHeight: 15,
              textAlign: TextAlign.left,
              controller: controller,
              onChanged: (value) {},
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
  Color startTimeButtonColor =
      const Color.fromARGB(255, 252, 252, 252); // Start time button color
  Color endTimeButtonColor =
      const Color.fromARGB(255, 0, 0, 0); // End time button color

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
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
            },
            child: ValueListenableBuilder<TimeOfDay>(
              valueListenable: startTimeNotifier,
              builder: (context, startTime, _) {
                return Text(
                  'Start: ${startTime.format(context)}',
                  style: const TextStyle(color: Colors.black, fontSize: 12),
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

                endTimeNotifier.value = pickedEndTime;
              }
            },
            child: ValueListenableBuilder<TimeOfDay>(
              valueListenable: endTimeNotifier,
              builder: (context, endTime, _) {
                return Text(
                  'End: ${endTime.format(context)}',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 10), // Spacing
        // Button to choose color (end time button color)
        const ButtonColorPickerRow()
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
            width: realContainerSizeX / 4 + 5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
              onPressed: () {
                applyNowSchedule(context);
              },
              style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8), // 여기서 원하는 정도의 둥근 정도 조절
                ),
              ),
              child: const Text(
                "Apply",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: realContainerSizeX / 4 + 5,
            height: weekContainerSizeY / 11,
            child: ElevatedButton(
                onPressed: () {
                  deleteNowSchedule();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8), // 여기서 원하는 정도의 둥근 정도 조절
                  ),
                ),
                child: const Text(
                  "Delete",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.0),
                ))),
      )
    ]);
  }
}

class ButtonColorPickerRow extends StatefulWidget {
  const ButtonColorPickerRow({Key? key}) : super(key: key);

  @override
  State<ButtonColorPickerRow> createState() => _ButtonColorPickerRowState();
}

class _ButtonColorPickerRowState extends State<ButtonColorPickerRow> {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "Button Color: ",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        // ValueListenableBuilder change colorButtonColor value
        ValueListenableBuilder<Color>(
          valueListenable: colorButtonColor,
          builder: (context, color, child) {
            return SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, // colorButtonColor.value use
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () async {
                  Color selectedColor =
                      await showColorPickerDialog(context, color);
                  colorButtonColor.value = selectedColor;
                },
                child: const Text(""),
              ),
            );
          },
        ),
      ],
    );
  }
}

// Color Picker Dialog
Future<Color> showColorPickerDialog(
    BuildContext context, Color initialColor) async {
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

class AlarmToggle extends StatefulWidget {
  const AlarmToggle({super.key});

  @override
  _AlarmToggleState createState() => _AlarmToggleState();
}

class _AlarmToggleState extends State<AlarmToggle> {
  final TextEditingController _timeController = alarmTimeTextFieldControllers;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 10),
        const Text(
          "Alarm\nTime",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
        ),
        const SizedBox(width: 10),
        SizedBox(
            width: 40,
            height: 40,
            child: TextField(
              controller: _timeController,
              keyboardType: TextInputType.number,
              maxLength: 2,
              maxLengthEnforcement: MaxLengthEnforcement.none,
              decoration: const InputDecoration(
                hintText: '10',
                border: OutlineInputBorder(),
                contentPadding:
                    EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                counterText: '',
              ),
              style: const TextStyle(fontSize: 14),
            )),
        const SizedBox(width: 10),
        // Use ValueListenableBuilder to rebuild when the value changes
        ValueListenableBuilder<bool>(
          valueListenable: alarmToggleFlag,
          builder: (context, value, child) {
            return Transform.scale(
              scale: 0.9,
              child: Switch(
                value: value,
                onChanged: (bool newValue) {
                  alarmToggleFlag.value = newValue; // Update the ValueNotifier
                },
              ),
            );
          },
        ),
      ],
    );
  }
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
