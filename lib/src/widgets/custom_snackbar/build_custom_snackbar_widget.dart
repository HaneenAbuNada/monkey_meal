import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

showSuccessSnackBar(String title, int duration, BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: Duration(seconds: duration),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
    margin: EdgeInsets.all(15.w),
    backgroundColor: CupertinoColors.activeGreen,
    behavior: SnackBarBehavior.floating,
    content: Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(Icons.check_circle_rounded, color: CupertinoColors.white, size: 30.w),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 18, color: CupertinoColors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  ),
);

showErrorSnackBar(String title, int duration, BuildContext context) => ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    duration: Duration(seconds: duration),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.w)),
    margin: EdgeInsets.all(15.w),
    backgroundColor: CupertinoColors.destructiveRed,
    behavior: SnackBarBehavior.floating,
    content: Row(
      spacing: 10,
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Icon(Icons.error_outline_rounded, color: CupertinoColors.white, size: 30.w),
        Expanded(
          child: Text(
            title,
            maxLines: 2,
            overflow: TextOverflow.fade,
            style: TextStyle(fontSize: 18, color: CupertinoColors.white, fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  ),
);
