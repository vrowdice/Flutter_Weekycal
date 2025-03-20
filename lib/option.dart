import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart';
import 'popup.dart';

class OptionBtn extends StatefulWidget {
  const OptionBtn({super.key});

  @override
  _OptionBtnState createState() => _OptionBtnState();
}

class _OptionBtnState extends State<OptionBtn> {
  bool weekendToggle = isRemoveWeekend;  // Managing state for weekend toggle here.

  void _showOptionsDialog(BuildContext context) {
    final TextEditingController controllerMin = TextEditingController();
    final TextEditingController controllerMax = TextEditingController();
    String minTimeTextfield = minTime.toString();
    String maxTimeTextfield = maxTime.toString();

    controllerMin.text = minTimeTextfield;
    controllerMax.text = maxTimeTextfield;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) { // 다이얼로그 내부 상태 업데이트
            return AlertDialog(
              title: const Text(
                'Options',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const Text(
                            "Remove Weekend",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Switch(
                            value: weekendToggle,
                            onChanged: (value) {
                              setStateDialog(() { // 다이얼로그 UI 업데이트
                                weekendToggle = value;
                              });
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Min Time",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: TextField(
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: controllerMin,
                              cursorHeight: 15,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                minTimeTextfield = value;
                              },
                              decoration: const InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            "Max Time",
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 10),
                          SizedBox(
                            width: 150,
                            height: 40,
                            child: TextField(
                              maxLength: 2,
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: controllerMax,
                              cursorHeight: 15,
                              textAlign: TextAlign.left,
                              onChanged: (value) {
                                maxTimeTextfield = value;
                              },
                              decoration: const InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.symmetric(
                                    vertical: 5, horizontal: 10),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Change the value and restart the app",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    int minVal = int.parse(minTimeTextfield);
                    int maxVal = int.parse(maxTimeTextfield);

                    if (minVal < 0 || minVal > 23 || maxVal < 1 || maxVal > 24) {
                      showWarningDialog(context, "Time is out of range");
                      return;
                    }
                    if (minVal > maxVal) {
                      showWarningDialog(
                          context, "The minimum time is greater than the maximum time.");
                      return;
                    }

                    minTime = minVal;
                    maxTime = maxVal;
                    isRemoveWeekend = weekendToggle;  // 변경 사항 적용

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
}