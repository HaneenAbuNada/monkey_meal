import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget customTextField({
  required TextEditingController controller,
  required String hintText,
  String? Function(String?)? validator,
  bool obscureText = false,
  TextInputType keyboardType = TextInputType.text,
  Widget? suffixWidget,
}) => TextFormField(
  controller: controller,
  keyboardType: TextInputType.emailAddress,
  validator: validator,
  obscureText: obscureText,
  decoration: InputDecoration(
    hintText: hintText,
    suffixStyle: const TextStyle(color: AppColor.orange),
    suffixIcon: suffixWidget ?? SizedBox(),
    fillColor: const Color(0xFFe5e5e5),
    filled: true,
    hintStyle: const TextStyle(color: Color(0xFFbcb8b1)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 20.0),
    border: const OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(20.0)),
      borderSide: BorderSide.none,
    ),
  ),
);
