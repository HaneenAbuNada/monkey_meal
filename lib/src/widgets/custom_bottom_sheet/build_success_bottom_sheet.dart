import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/core/helper/helper.dart';
import 'package:monkey_meal/src/screens/app/layout.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';

class OrderSuccessBottomSheet extends StatelessWidget {
  const OrderSuccessBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/order_done.png',
              width: context.getScreenWidth,
              height: context.getScreenHeight * 0.3,
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank You!',
              style: TextStyle(fontFamily: 'Metropolis', fontWeight: FontWeight.w900, fontSize: 24),
            ),
            const SizedBox(height: 8),
            const Text(
              'for your order',
              style: TextStyle(fontFamily: 'Metropolis', fontWeight: FontWeight.w900, fontSize: 24),
            ),
            const SizedBox(height: 24),
            const Text(
              'Your Order is now being processed. We will let you know once the order is picked from the outlet. Check the status of your Order',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 24),
            customButton(press: () {}, title: 'Track my order'),
            SizedBox(height: 8),
            InkWell(
              onTap: () {
                NavAndAnimationsFunctions.navAndFinish(context, Layout());
              },
              child: Text('Back to home', style: TextStyle(fontWeight: FontWeight.w900)),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
