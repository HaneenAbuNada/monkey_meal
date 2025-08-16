import 'package:flutter/material.dart';

extension ScreenSizeExtension on BuildContext {
  double get getScreenWidth => MediaQuery.of(this).size.width;

  double get getScreenHeight => MediaQuery.of(this).size.height;
}
