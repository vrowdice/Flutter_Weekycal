import 'package:flutter/material.dart';

// 경고 다이얼로그를 재사용할 수 있는 메소드
void showWarningDialog(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text(
          "Warning",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 다이얼로그 닫기
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
