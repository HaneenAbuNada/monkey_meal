import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

// Widget buildFavouriteWidget() => Transform.rotate(
//   angle: -8 * math.pi / 180,
//   child: CustomPaint(
//     painter: CurvedRightTrianglePainter(),
//     child: SizedBox(
//       width: 100,
//       height: 100,
//       child: Center(child: Icon(Icons.favorite, color: AppColor.orange, size: 30)),
//     ),
//   ),
// );
Widget buildFavouriteWidget({required bool isFavorite}) => Transform.rotate(
  angle: -8 * math.pi / 180,
  child: CustomPaint(
    painter: CurvedRightTrianglePainter(),
    child: SizedBox(
      width: 100,
      height: 100,
      child: Center(child: Icon(isFavorite ? Icons.favorite : Icons.favorite_border, color: AppColor.orange, size: 30)),
    ),
  ),
);

class CurvedRightTrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..color = Colors.white
          ..style = PaintingStyle.fill;

    final path = Path();
    double w = size.width;
    double h = size.height;
    path.moveTo(w * 0.15, h * 0.15);
    path.quadraticBezierTo(0, h * 0.5, w * 0.15, h * 0.85);
    path.quadraticBezierTo(w * 0.65, h, w * 0.95, h * 0.5);
    path.quadraticBezierTo(w * 0.65, 0, w * 0.15, h * 0.15);
    canvas.drawShadow(path, Colors.black.withValues(alpha: 0.25), 6, true);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
