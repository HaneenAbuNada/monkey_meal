import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget rowWidget({required String title, required String post}) => Row(
  mainAxisAlignment: MainAxisAlignment.spaceBetween,
  children: [
    Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
    Text(post, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColor.orange)),
  ],
);
