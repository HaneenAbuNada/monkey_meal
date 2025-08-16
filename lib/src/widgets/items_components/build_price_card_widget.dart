import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';

Widget priceCardWidget({required double totalPrice, required void Function() addToCardFunction}) => LayoutBuilder(
  builder: (context, constraints) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        CustomPaint(size: Size(constraints.maxWidth, constraints.maxHeight), painter: OrangeShapePainter()),
        Center(
          child: Container(
            margin: EdgeInsets.only(right: 60, left: 60),
            width: double.infinity,
            height: 150,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
            ),
            child: Card(
              elevation: 15,
              color: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    bottomLeft: Radius.circular(40),
                    bottomRight: Radius.circular(0),
                    topRight: Radius.circular(0),
                  ),
                  side: BorderSide(color: Colors.black12)
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                spacing: 4,
                children: [
                  const Text('Total Price', style: TextStyle(fontSize: 14)),
                  Text('LKR $totalPrice', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(
                    width: 150,
                    height: 40,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColor.orange,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      ),
                      onPressed: addToCardFunction,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        spacing: 5,
                        children: [
                          Icon(Icons.shopping_bag, color: Colors.white, size: 15),
                          const Text(
                            'Add to Cart',
                            style: TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(25.0),
          child: Align(
            alignment: AlignmentDirectional.centerEnd,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              foregroundColor: Colors.black12,
              radius: 25,
              child: Icon(Icons.shopping_bag, color: AppColor.orange),
            ),
          ),
        ),
      ],
    );
  },
);

class OrangeShapePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = AppColor.orange;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width * 0.35, 0);
    path.quadraticBezierTo(size.width * 0.6, size.height / 2, size.width * 0.35, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
