import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget buildPaymentMethodItem({required String title, String? subtitle, String? imagePath}) => GestureDetector(
  onTap: () {},
  child: Container(
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      boxShadow: [
        BoxShadow(color: Colors.grey.withValues(alpha: 0.2), spreadRadius: 1, blurRadius: 5, offset: Offset(0, 3)),
      ],
    ),
    child: Row(
      children: [
        if (imagePath != null) ...[Image.asset(imagePath, height: 24, width: 24), SizedBox(width: 16)],
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              if (subtitle != null) ...[
                SizedBox(height: 4),
                Text(subtitle, style: TextStyle(color: Colors.grey, fontSize: 14)),
              ],
            ],
          ),
        ),
        Radio(groupValue: 3, onChanged: (int? value) {}, activeColor: AppColor.orange, value: 1),
      ],
    ),
  ),
);
