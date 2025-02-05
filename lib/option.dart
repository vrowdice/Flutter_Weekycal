import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart'; // 가정: saveData 함수가 정의된 파일
import 'popup.dart';    // 가정: showWarningDialog 함수가 정의된 파일

class OptionBtn extends StatefulWidget {
  const OptionBtn({super.key});

  @override
  State<OptionBtn> createState() => _OptionBtnState();
}

class _OptionBtnState extends State<OptionBtn> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 50,
      height: 50,
      child: IconButton(
        icon: const Icon(
          Icons.settings,
          size: 30,
        ),
        onPressed: () => _showOptionsDialog(context),
      ),
    );
  }

  void _showOptionsDialog(BuildContext context) {
    bool currentWeekendToggle = isRemoveWeekend;

    final TextEditingController controllerMin = TextEditingController(text: minTime.toString());
    final TextEditingController controllerMax = TextEditingController(text: maxTime.toString());


    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text(
                'Options',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView( // Added for scrollability
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Improved layout
                      children: [
                        const Text(
                          "Remove Weekend",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Switch(
                          value: currentWeekendToggle,
                          onChanged: (value) {
                            setState(() {
                              currentWeekendToggle = value;
                            });
                          },
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _buildTextFieldRow(setState, "Min Time", controllerMin),
                    const SizedBox(height: 10),
                    _buildTextFieldRow(setState, "Max Time", controllerMax),
                    const SizedBox(height: 10),
                    const Text(
                      "Change the value and restart the app",
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int minVal = int.tryParse(controllerMin.text) ?? minTime;  // Use tryParse and provide default
                    int maxVal = int.tryParse(controllerMax.text) ?? maxTime;  // Use tryParse and provide default

                    if (minVal < 0 || minVal > 23 || maxVal < 1 || maxVal > 24) {
                      showWarningDialog(context, "Time is out of range");
                      return;
                    }
                    if (minVal > maxVal) {
                      showWarningDialog(context, "The minimum time is greater than the maximum time.");
                      return;
                    }

                    minTime = minVal;
                    maxTime = maxVal;
                    isRemoveWeekend = currentWeekendToggle;

                    saveData();

                    Navigator.pop(context);
                  },
                  child: const Text('Apply'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Close'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Row _buildTextFieldRow(StateSetter setState, String label, TextEditingController controller) {
    return Row(
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 10),
        Expanded( // Use Expanded to fill available space
          child: SizedBox(
            height: 40,
            child: TextField(
              maxLength: 2,
              keyboardType: TextInputType.number,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              controller: controller,
              cursorHeight: 15,
              textAlign: TextAlign.left,
              onChanged: (value) {
                setState(() { // No need to update separate variables, controller is already updated
                });
              },
              decoration: const InputDecoration(
                counterText: "",
                contentPadding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                border: OutlineInputBorder(),
              ),
            ),
          ),
        ),
      ],
    );
  }
}