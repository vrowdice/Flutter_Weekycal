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
            height: 120,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text("Enter Save File Name"),
                TextField(
                  controller: _textController,
                  maxLength: 15,
                  cursorHeight: 15,
                  textAlign: TextAlign.left,
                  decoration: const InputDecoration(
                    counterText: "",
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
              onPressed: () async {
                String fileName = _textController.text.trim();

                if (fileName.isNotEmpty) {
                  bool exists = await isFileNameExists(fileName);

                  if (exists) {
                    // if file is exist
                    bool? overwrite = await showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Confirm Overwrite',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        content:
                            Text('File "$fileName" already exists. Overwrite?'),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(context, true),
                            child: const Text('Yes'),
                          ),
                          TextButton(
                            onPressed: () => Navigator.pop(context, false),
                            child: const Text('No'),
                          ),
                        ],
                      ),
                    );

                    if (overwrite == true) {
                      saveScheduleData(fileName);
                    }
                  } else {
                    // if no same file name
                    saveScheduleData(fileName);
                  }
                }

                Navigator.pop(context); // Close save dialog
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
                height: 350,
                child: SingleChildScrollView(
                  child: Column(
                    children: strList.map((scheduleName) {
                      return Padding(
                        padding: const EdgeInsets.all(5),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 40, 40, 40),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0),
                            ),
                          ),
                          onPressed: () async {
                            bool? confirmLoad = await showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm Load',
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold)),
                                content: Text(
                                    'Load "$scheduleName"?\nunsaved information will be lost.'),
                                actions: [
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, true),
                                    child: const Text('Yes'),
                                  ),
                                  TextButton(
                                    onPressed: () =>
                                        Navigator.pop(context, false),
                                    child: const Text('No'),
                                  ),
                                ],
                              ),
                            );

                            if (confirmLoad == true) {
                              loadScheduleData(scheduleName);
                              Navigator.pop(context);
                            }
                          },
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
