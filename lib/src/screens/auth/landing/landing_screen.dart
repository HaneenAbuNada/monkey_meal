import 'package:flutter/material.dart';
import 'package:monkey_meal/core/helper/helper.dart';
import '../../../../core/consts/colors/colors.dart';
import '../../../../core/consts/functions/animations.dart';
import '../../../widgets/custom_button/build_custom_button.dart';
import '../login/log_in_screen.dart';
import '../register/sign_up_screen.dart';


class LandingScreen extends StatelessWidget {
  static const routeName = "/landingScreen";

  const LandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: context.getScreenWidth,
        height: context.getScreenHeight,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: CustomPaint(
                      painter: ShadowPainter(
                        clipper: CustomClipperAppBar(),
                        boxShadow: const BoxShadow(color: AppColor.placeholder, offset: Offset(0, 15), blurRadius: 10),
                      ),
                    ),
                  ),
                  ClipPath(
                    clipper: CustomClipperAppBar(),
                    child: Container(
                      width: double.infinity,
                      height: context.getScreenHeight * 0.5,
                      decoration: ShapeDecoration(
                        color: AppColor.orange,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                      child: Image.asset(
                        'assets/images/login_bg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/MealMonkeyLogo.png',
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                height: context.getScreenHeight * 0.3,
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  children: [
                    const Flexible(
                      child: Text(
                        "Discover the best foods from over 1,000 restaurants and fast delivery to your doorstep",
                        textAlign: TextAlign.center,
                        style: TextStyle(color: AppColor.primary, fontSize: 15),
                      ),
                    ),
                    const Spacer(flex: 1),
                    customButton(
                      press: () => NavAndAnimationsFunctions.navToWithLTRAnimation(context, LoginScreen()),
                      title: "Login",
                    ),
                    const SizedBox(height: 20),
                    customOutlinedButton(
                      press: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, SignUpScreen()),
                      title: "Create an account",
                    ),
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomClipperAppBar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Offset controlPoint = Offset(size.width * 0.24, size.height);
    Offset endPoint = Offset(size.width * 0.25, size.height * 0.96);
    Offset controlPoint2 = Offset(size.width * 0.3, size.height * 0.78);
    Offset endPoint2 = Offset(size.width * 0.5, size.height * 0.78);
    Offset controlPoint3 = Offset(size.width * 0.7, size.height * 0.78);
    Offset endPoint3 = Offset(size.width * 0.75, size.height * 0.96);
    Offset controlPoint4 = Offset(size.width * 0.76, size.height);
    Offset endPoint4 = Offset(size.width * 0.79, size.height);
    Path path =
        Path()
          ..lineTo(0, size.height)
          ..lineTo(size.width * 0.21, size.height)
          ..quadraticBezierTo(controlPoint.dx, controlPoint.dy, endPoint.dx, endPoint.dy)
          ..quadraticBezierTo(controlPoint2.dx, controlPoint2.dy, endPoint2.dx, endPoint2.dy)
          ..quadraticBezierTo(controlPoint3.dx, controlPoint3.dy, endPoint3.dx, endPoint3.dy)
          ..quadraticBezierTo(controlPoint4.dx, controlPoint4.dy, endPoint4.dx, endPoint4.dy)
          ..lineTo(size.width, size.height)
          ..lineTo(size.width, 0);

    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class ShadowPainter extends CustomPainter {
  final CustomClipper<Path> clipper;
  final BoxShadow boxShadow;

  ShadowPainter({required this.clipper, required this.boxShadow});

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = clipper.getClip(size);

    final Matrix4 matrix4 = Matrix4.identity();
    matrix4.translate(boxShadow.offset.dx, boxShadow.offset.dy);
    final Path offsetPath = path.transform(matrix4.storage);

    // Dessiner l'ombre
    canvas.drawShadow(offsetPath, boxShadow.color, boxShadow.blurRadius, true);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
