import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart';
import 'popup.dart';

class OptionBtn extends StatelessWidget {
  const OptionBtn({super.key});

  void _showOptionsDialog(BuildContext context) {
    final TextEditingController controllerMin = TextEditingController();
    final TextEditingController controllerMax =
        TextEditingController(); // Controller for the TextField
    String minTimeTextfield = minTime.toString();
    String maxTimeTextfield = maxTime.toString();

    controllerMin.text = minTimeTextfield;
    controllerMax.text = maxTimeTextfield;

    showDialog(
      context: context,
      builder: (context) {
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
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Align label and field vertically
                    children: [
                      const Text(
                        "Min Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Add spacing between label and input field
                      SizedBox(
                        width: 150, // Adjust the width as needed
                        height: 40, // Adjust the height as needed
                        child: TextField(
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only digits
                          ],
                          controller: controllerMin,
                          cursorHeight: 15,
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            minTimeTextfield = value;
                          },
                          decoration: const InputDecoration(
                            counterText: "", // Removes the character counter
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                      height: 10), // Add spacing between Min Time and Max Time
                  Row(
                    crossAxisAlignment: CrossAxisAlignment
                        .center, // Align label and field vertically
                    children: [
                      const Text(
                        "Max Time",
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                          width:
                              10), // Add spacing between label and input field
                      SizedBox(
                        width: 150, // Adjust the width as needed
                        height: 40, // Adjust the height as needed
                        child: TextField(
                          maxLength: 2,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter
                                .digitsOnly, // Allows only digits
                          ],
                          controller: controllerMax,
                          cursorHeight: 15,
                          textAlign: TextAlign.left,
                          onChanged: (value) {
                            maxTimeTextfield = value;
                          },
                          decoration: const InputDecoration(
                            counterText: "", // Removes the character counter
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 5, horizontal: 10),
                            border: OutlineInputBorder(),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10,),
                  const Text(
                    "Change the value and restart the app",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  )
                ],
              )
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
                  showWarningDialog(context,
                      "The minimum time is greater than the maximum time.");
                  return;
                }

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
