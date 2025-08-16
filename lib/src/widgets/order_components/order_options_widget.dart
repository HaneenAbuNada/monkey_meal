import 'package:flutter/material.dart';

import '../items_components/build_drop_down_widget.dart';

Widget orderOptions() => Padding(
  padding: const EdgeInsets.symmetric(vertical: 30),
  child: Container(
    color: Colors.grey.shade300,
    child: Column(
      children: [
        buildDropdown('Cola x1', post: "14"),
        SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
        buildDropdown('Appetizers x1', post: "10"),
        SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
        buildDropdown('Bread x4', post: "7"),
        SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
        buildDropdown('Spoon x4', post: "2"),
        SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
        buildDropdown('Knife x4', post: "2"),
      ],
    ),
  ),
);