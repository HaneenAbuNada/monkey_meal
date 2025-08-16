import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

class InboxScreen extends StatelessWidget {
  InboxScreen({super.key});

  final List<Map<String, String>> items = List.generate(
    6,
    (index) => {
      "title": "MealMonkey Promotions",
      "subtitle": "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor",
      "date": "6th July",
    },
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "Inbox"),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        itemBuilder: (context, index) {
          final item = items[index];
          return ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.circle, color: Colors.red, size: 12),
            title: Text(item["title"]!, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            subtitle: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                item["subtitle"]!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.grey),
              ),
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(item["date"]!, style: const TextStyle(color: Colors.grey, fontSize: 12)),
                const SizedBox(height: 4),
                Icon(Icons.star_border, color: Colors.red.shade300, size: 20),
              ],
            ),
          );
        },
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemCount: items.length,
      ),
    );
  }
}
