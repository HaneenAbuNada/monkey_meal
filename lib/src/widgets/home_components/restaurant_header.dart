import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget restaurantHeader({
  required String title,
  String actionText = "View all",
  Color titleColor = AppColor.primary,
  Color actionColor = AppColor.orange,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(title, style: TextStyle(color: titleColor, fontSize: 20, fontWeight: FontWeight.bold)),
      Text(actionText, style: TextStyle(color: actionColor, fontSize: 14, fontWeight: FontWeight.w800)),
    ],
  ),
);
