import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';

Widget customButton({required void Function() press, required String title, Color color = AppColor.orange}) => SizedBox(
  width: double.infinity,
  height: 50,
  child: ElevatedButton(
    onPressed: press,
    style: ButtonStyle(backgroundColor: WidgetStateProperty.all(color)),
    child: Text(title, style: TextStyle(color: Colors.white, fontSize: 18)),
  ),
);

Widget customOutlinedButton({
  required void Function() press,
  required String title,
  double height = 50,
  double fontSize = 18,
}) => SizedBox(
  width: double.infinity,
  height: height,
  child: ElevatedButton(
    style: ButtonStyle(
      backgroundColor: WidgetStateProperty.all(Colors.white),
      foregroundColor: WidgetStateProperty.all(AppColor.orange),
      shape: WidgetStateProperty.all(const StadiumBorder(side: BorderSide(color: AppColor.orange, width: 1.5))),
    ),
    onPressed: press,
    child: Text(title, style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold)),
  ),
);
