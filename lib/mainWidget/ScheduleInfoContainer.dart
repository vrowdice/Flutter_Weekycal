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
        width: realContainerSizeX + 50,
        height: weekContainerSizeY / 2,
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: ContainerTitleText(
                        isNewScheduleNotifier: isNewSchadule)),
                const ScheduleControlRow()
              ],
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(5),
                  child: Container(
                    width: 175,
                    height: 120,
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
                    child: const TimePickerColum(),
                  ),
                ),
                const Column(
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

class ContainerTitleText extends StatefulWidget {
  final ValueNotifier<bool> isNewScheduleNotifier;
  const ContainerTitleText({super.key, required this.isNewScheduleNotifier});

  @override
  State<ContainerTitleText> createState() => _ContainerTitleTextState();
}

class _ContainerTitleTextState extends State<ContainerTitleText> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: widget.isNewScheduleNotifier,
      builder: (context, isNewSchedule, child) {
        return SizedBox(
          width: 170,
          child: Text(
            isNewSchedule ? "New Schedule Info" : "Schedule Info",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
            ),
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
        label = "Explanation";
        break;
      default:
        label = "";
    }

    // 전역변수로 사용되는 textFieldControllers에서 컨트롤러 참조
    TextEditingController controller = textFieldControllers[widget.index];

    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        children: [
          SizedBox(
            width: 75,
            child: Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 120, // 적절한 크기 설정
            height: 25, // 적절한 높이 설정
            child: TextField(
              maxLength: 12,
              keyboardType: TextInputType.text,
              decoration: const InputDecoration(
                contentPadding:
                    EdgeInsets.symmetric(vertical: 15.0, horizontal: 0.0),
                counterText: "",
              ),
              cursorHeight: 15,
              textAlign: TextAlign.left,
              controller: controller, // 전역 변수 사용
              onChanged: (value) {
                setState(() {
                  // 상태 변경이 필요하면 여기에 추가 작업
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
                  style: const TextStyle(color: Colors.white, fontSize: 12),
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
            width: realContainerSizeX / 4,
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
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
              ),
            )),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: SizedBox(
            width: realContainerSizeX / 4,
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
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.0),
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
        // ValueListenableBuilder를 사용하여 colorButtonColor 값 변경 시 UI 업데이트
        ValueListenableBuilder<Color>(
          valueListenable: colorButtonColor, // 값을 리스닝하는 위젯
          builder: (context, color, child) {
            return SizedBox(
              height: 25,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: color, // colorButtonColor.value 사용
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(0),
                  ),
                ),
                onPressed: () async {
                  Color selectedColor =
                      await showColorPickerDialog(context, color);
                  // 색상 선택 후 value 변경
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
