import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';

Widget buildRoundButton(IconData icon, void Function() onPressed) {
  return InkWell(
    onTap: onPressed,
    child: Container(
      width: 60,
      height: 30,
      decoration: BoxDecoration(
        color: AppColor.orange,
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(icon, color: Colors.white, size: 20),
    ),
  );
}
