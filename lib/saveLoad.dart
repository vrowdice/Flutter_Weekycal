import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart';
import 'popup.dart';

//main window save button and function
class SaveBtn extends StatefulWidget {
  const SaveBtn({super.key});

  @override
  _SaveBtnState createState() => _SaveBtnState();
}

class _SaveBtnState extends State<SaveBtn> {
  bool weekendToggle =
      isRemoveWeekend; // Managing state for weekend toggle here.

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Enter Save File Name"),
              TextField(
                maxLength: 2,
                cursorHeight: 15,
                textAlign: TextAlign.left,
                onChanged: (value) {},
                decoration: const InputDecoration(
                  counterText: "", // Removes character counter
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
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
          Icons.file_download,
          size: 30,
        ),
        onPressed: () => _showOptionsDialog(context),
      ),
    );
  }
}

//main window load button and function
class LoadBtn extends StatefulWidget {
  const LoadBtn({super.key});

  @override
  _LoadBtnState createState() => _LoadBtnState();
}

class _LoadBtnState extends State<LoadBtn> {
  bool weekendToggle =
      isRemoveWeekend; // Managing state for weekend toggle here.

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Options',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            children: [],
          ),
          actions: [
            TextButton(
              onPressed: () {
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
          Icons.file_upload,
          size: 30,
        ),
        onPressed: () => _showOptionsDialog(context),
      ),
    );
  }
}
