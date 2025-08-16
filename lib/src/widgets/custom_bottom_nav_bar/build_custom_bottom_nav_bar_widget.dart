import 'package:flutter/material.dart';
import 'package:monkey_meal/core/helper/helper.dart';

class CustomBottomNavBar extends StatelessWidget {
  const CustomBottomNavBar({super.key, required this.currentIndex, required this.onTap});

  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) {
    final screenWidth = context.getScreenWidth;

    return SizedBox(
      height: 90,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          CustomPaint(size: Size(screenWidth, 100), painter: BottomNavCurvePainter()),
          Positioned(
            bottom: 35,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavIcon(Icons.grid_view_sharp, 0, 'Menu'),
                _buildNavIcon(Icons.shopping_bag, 1, 'Offers'),
                const SizedBox(width: 80),
                _buildNavIcon(Icons.person, 3, 'Profile'),
                _buildNavIcon(Icons.read_more_outlined, 4, 'More'),
              ],
            ),
          ),
          Positioned(
            top: -35,
            left: screenWidth / 2 - 40,
            child: GestureDetector(
              onTap: () => onTap(2),
              child: Container(
                height: 80,
                width: 80,
                decoration: BoxDecoration(
                  color: currentIndex == 2 ? Colors.orange : Colors.grey,
                  shape: BoxShape.circle,
                  boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 15, offset: const Offset(0, -5))],
                ),
                child: const Icon(Icons.home, color: Colors.white, size: 45),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavIcon(IconData icon, int index, String iconName) {
    return GestureDetector(
      onTap: () => onTap(index),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: currentIndex == index ? Colors.orange : Colors.grey, size: 20),
          const SizedBox(height: 4),
          Text(
            iconName,
            style: TextStyle(
              fontSize: 12,
              color: currentIndex == index ? Colors.orange : Colors.grey,
              fontWeight: currentIndex == index ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

class BottomNavCurvePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final double width = size.width;
    final double height = size.height;

    // Path of bottom nav background
    final path = Path()
      ..moveTo(0, 0)
      ..lineTo(width * 0.30, 0)
      ..quadraticBezierTo(width * 0.34, 0, width * 0.375, 30)
      ..arcToPoint(
        Offset(width * 0.625, 30),
        radius: Radius.circular(50),
        clockwise: false,
      )
      ..quadraticBezierTo(width * 0.66, 0, width * 0.70, 0)
      ..lineTo(width, 0)
      ..lineTo(width, height)
      ..lineTo(0, height)
      ..close();

    // Gradient shadow
    final shadowGradient = LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [
        Colors.black.withValues(alpha: 0.9),
        Colors.transparent,
      ],
    );

    final shadowPaint = Paint()
      ..shader = shadowGradient.createShader(
        Rect.fromLTWH(0, 0, width, height + 400),
      )
      ..maskFilter = MaskFilter.blur(BlurStyle.normal, 60);

    // White background paint
    final backgroundPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    // Draw shadow first
    canvas.drawPath(path, shadowPaint);

    // Draw background on top
    canvas.drawPath(path, backgroundPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
