import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "Notification"),
      body: ListView.builder(
        itemCount: 8,
        itemBuilder: (context, index) {
          final isRecent = index < 2;
          return ListTile(
            leading: const Padding(
              padding: EdgeInsets.only(top: 8.0),
              child: Icon(Icons.circle, color: Colors.orange, size: 10),
            ),
            title: const Text('Your order has been delivered', style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text(isRecent ? '1 h ago' : '12 Aug 2020', style: const TextStyle(color: Colors.grey)),
          );
        },
      ),
    );
  }
}
