import 'package:flutter/material.dart';

Widget buildDropdown(String hint, {String? post}) => Container(
  width: double.infinity,
  height: 40,
  margin: const EdgeInsets.symmetric(horizontal: 14),
  decoration: BoxDecoration(border: Border.all(color: Colors.grey.shade300), color: Colors.grey.shade300),
  child: Center(
    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(hint, style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          Text(post?.isNotEmpty == true ? '\$$post' : '-', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  ),
);
