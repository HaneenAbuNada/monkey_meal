import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "About Us"),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _listItem(
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
                SizedBox(height: 20),
                _listItem(
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.',
                ),
                SizedBox(height: 20),
                _listItem(
                  text:
                      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _listItem({required String text}) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        margin: const EdgeInsets.only(top: 8, right: 10),
        width: 8,
        height: 8,
        decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
      ),
      Expanded(child: Text(text, style: const TextStyle(fontSize: 16))),
    ],
  );
}
