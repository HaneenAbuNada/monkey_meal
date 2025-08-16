import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/screens/app/more/favourite_screen.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

import '../../../manage/auth_cubit/login_cubit/login_cubit.dart';
import '../order/orders_screen.dart';
import '../payments/payment_screen.dart';
import 'about_me_screen.dart';
import 'inbox_screen.dart';
import 'notification_screen.dart';

class MoreView extends StatelessWidget {
  const MoreView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "More"),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          _moreItem(
            icon: Icons.monetization_on,
            title: 'Payment Details',
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, PaymentScreen()),
          ),
          _moreItem(
            icon: Icons.shopping_bag,
            title: 'My Orders',
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, OrderScreen()),
          ),
          _moreItem(
            icon: Icons.favorite,
            title: 'Favourites',
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, FavoritesScreen()),
          ),
          _moreItem(
            icon: Icons.notifications,
            title: 'Notifications',
            badge: 15,
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, NotificationScreen()),
          ),
          _moreItem(
            icon: Icons.inbox,
            title: 'Inbox',
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, InboxScreen()),
          ),
          _moreItem(
            icon: Icons.info,
            title: 'About Us',
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, AboutScreen()),
          ),
          _moreItem(
            icon: Icons.logout,
            title: 'Logout',
            textColor: CupertinoColors.white,
            iconBackground: Colors.redAccent.shade100,
            iconColor: CupertinoColors.systemRed.highContrastElevatedColor,
            background: Colors.redAccent,
            postColor: Colors.white,
            onTap: () {
              showDialog(
                context: context,
                builder:
                    (context) => AlertDialog(
                      title: const Text('Logout Confirmation!'),
                      content: const Text('Are you sure that you want to logout?'),
                      actions: [
                        TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            LoginCubit.get(context).logout(context);
                          },
                          child: const Text('Logout', style: TextStyle(color: Colors.red)),
                        ),
                      ],
                    ),
              );
            },
          ),
        ],
      ),
    );
  }
}

Widget _moreItem({
  required IconData icon,
  required String title,
  void Function()? onTap,
  int? badge,
  Color iconColor = AppColor.secondary,
  Color background = AppColor.placeholderBg,
  Color iconBackground = AppColor.placeholder,
  Color textColor = AppColor.secondary,
  Color postColor = AppColor.primary,
}) => InkWell(
  onTap: onTap,
  child: Stack(
    alignment: AlignmentDirectional.centerStart,
    children: [
      Card(
        elevation: 0,
        color: background,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        margin: const EdgeInsets.only(top: 8.0, right: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: iconBackground, borderRadius: BorderRadius.circular(50)),
                child: Icon(icon, color: iconColor),
              ),
              const SizedBox(width: 16),
              Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: textColor)),
              const Spacer(),
              if (badge != null)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(color: Colors.red.shade700, borderRadius: BorderRadius.circular(12)),
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                  child: Text(
                    '$badge',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(width: 10),
            ],
          ),
        ),
      ),
      Align(
        alignment: Alignment(0.99, 0.0),
        child: CircleAvatar(
          radius: 15,
          backgroundColor: background,
          child: Icon(Icons.arrow_forward_ios, size: 16, color: postColor),
        ),
      ),
    ],
  ),
);
