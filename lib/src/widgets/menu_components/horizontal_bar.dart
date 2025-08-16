import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/consts/colors/colors.dart';

Widget horizontalBar({void Function()? onTap, required String title, required String count}) => GestureDetector(
  onTap: onTap,
  child: Container(
    height: 80.h,
    width: 280.w,
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(35.r),
        bottomLeft: Radius.circular(35.r),
        topRight: Radius.circular(12.r),
        bottomRight: Radius.circular(12.r),
      ),
      boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 5))],
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: SizedBox()),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(child: SizedBox()),
              Text(title, style: TextStyle(color: AppColor.primary, fontSize: 19, fontWeight: FontWeight.w700)),
              Text(
                "$count items",
                style: TextStyle(color: AppColor.placeholder, fontSize: 11, fontWeight: FontWeight.w500),
              ),
              Expanded(child: SizedBox()),
            ],
          ),
        ),
        Expanded(child: SizedBox()),
      ],
    ),
  ),
);
