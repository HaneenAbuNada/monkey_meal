import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';

Widget longSideBar() => Container(
  height: 485.h,
  width: 97.w,
  decoration: BoxDecoration(
    color: AppColor.orange,
    borderRadius: BorderRadius.only(topRight: Radius.circular(35.r), bottomRight: Radius.circular(35.r)),
  ),
);
