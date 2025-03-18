import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart';

//main window save button and function
import 'package:flutter/material.dart';

class SaveBtn extends StatefulWidget {
  const SaveBtn({super.key});

  @override
  _SaveBtnState createState() => _SaveBtnState();
}

class _SaveBtnState extends State<SaveBtn> {
  final TextEditingController _textController =
      TextEditingController(); // Controller to store user input

  void _showOptionsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Save',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 70,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter Save File Name"),
                TextField(
                  controller:
                      _textController, // Connect controller to store text input
                  maxLength: 10, // Allow longer file names
                  cursorHeight: 15,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    counterText: "", // Remove character counter
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                String fileName = _textController.text.trim(); // Get user input

                if (fileName.isNotEmpty) {
                  saveScheduleData(fileName); // Save using entered name
                }

                Navigator.pop(context); // Close dialog
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
        onPressed: () => _showOptionsDialog(context), // Open save dialog
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
  void _showOptionsDialog(BuildContext context) {
    List<String> strList;
    Future<void> loadSavedData() async {
      strList =
          await getSavedScheduleList(); // Await the Future to get the List<String>
      print(strList); // Now you can use the list
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Load',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SizedBox(
            height: 250,
            child: Column(
              children: [],
            ),
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
