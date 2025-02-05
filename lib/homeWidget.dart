import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'dart:typed_data';

class HomeWidgetExampleProvider extends StatelessWidget {
  const HomeWidgetExampleProvider({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _loadWidgetData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator(); // Show loading indicator
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          final title = snapshot.data?['title'] ?? 'Default Title';
          final message = snapshot.data?['message'] ?? 'Default Message';
          final dashIcon = snapshot.data?['dashIcon']
              as Widget?; // Retrieve the rendered icon

          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white, // Example background color
              borderRadius: BorderRadius.circular(8), // Example border radius
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                if (dashIcon != null) ...[
                  // Conditionally render the icon
                  const SizedBox(height: 8),
                  dashIcon,
                ],
                // Add an interactive button
                TextButton(
                  onPressed: () async {
                    await HomeWidget.setAppGroupId(
                        'YOUR_GROUP_ID'); // Important! Set group ID
                    await HomeWidget.updateWidget(
                      // Signal interaction
                      name: 'HomeWidgetExampleProvider', // Your provider name
                      iOSName: 'HomeWidgetExample', // Your iOS widget name
                      qualifiedAndroidName:
                          'es.antonborri.home_widget_example.glance.HomeWidgetReceiver', // Android receiver
                      // You can optionally pass data here, though it won't be used for this specific example:
                      // data: {'clicked': true},
                    );
                  },
                  child: const Text('Click Me!'),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _loadWidgetData() async {
    await HomeWidget.setAppGroupId('YOUR_GROUP_ID'); // Ensure group ID is set

    final title = await HomeWidget.getWidgetData<String>('title');
    final message = await HomeWidget.getWidgetData<String>('message');
    final dashIconBytes = await HomeWidget.getWidgetData<Uint8List>(
        'dashIcon'); // Retrieve the icon bytes

    Widget? dashIcon;
    if (dashIconBytes != null) {
      dashIcon = Image.memory(dashIconBytes); // Create an Image from the bytes
    }

    return {'title': title, 'message': message, 'dashIcon': dashIcon};
  }
}
