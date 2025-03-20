import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'saveData.dart';

//main window save button and function
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

class LoadBtn extends StatefulWidget {
  const LoadBtn({super.key});

  @override
  _LoadBtnState createState() => _LoadBtnState();
}

class _LoadBtnState extends State<LoadBtn> {
  Future<void> _showOptionsDialog(BuildContext context) async {
    List<String> strList = await getSavedScheduleList(); // 저장된 리스트 로드

    if (!mounted) return; // 다이얼로그가 사라지는 경우 방지

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setStateDialog) {
            return AlertDialog(
              title: const Text(
                'Load',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              content: SizedBox(
                height: 250,
                child: SingleChildScrollView(
                  child: Column(
                    children: strList.map((scheduleName) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          onPressed: () {}, // 선택 시 실행할 기능 추가 가능
                          child: SizedBox(
                            width: 200,
                            height: 50,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(scheduleName),
                                IconButton(
                                  onPressed: () async {
                                    await deleteScheduleData(scheduleName);
                                    List<String> updatedList =
                                        await getSavedScheduleList();

                                    setStateDialog(() {
                                      strList = updatedList; // 다이얼로그 내부 UI 업데이트
                                    });
                                  },
                                  icon: const Icon(
                                    Icons.delete,
                                    size: 30,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              actions: [
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
          Icons.file_upload,
          size: 30,
        ),
        onPressed: () => _showOptionsDialog(context),
      ),
    );
  }
}
