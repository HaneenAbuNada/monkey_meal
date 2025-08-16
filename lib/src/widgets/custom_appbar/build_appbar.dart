import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';

import '../../../core/consts/functions/animations.dart';
import '../../screens/app/payments/payment_screen.dart';

PreferredSizeWidget customAppbar(context, {required String title}) => AppBar(
  backgroundColor: Colors.white,
  title: Text(title, style: TextStyle(color: AppColor.primary, fontSize: 24, fontWeight: FontWeight.bold)),
  actions: [
    IconButton(
      onPressed: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, PaymentScreen()),
      icon: Icon(Icons.shopping_cart, color: AppColor.primary, size: 20),
    ),
  ],
);