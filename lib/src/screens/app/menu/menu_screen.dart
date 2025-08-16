import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/model/menu_model.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../widgets/custom_appbar/build_appbar.dart';
import '../../../widgets/custom_appbar/build_search_appbar.dart';
import '../../../widgets/menu_components/horizontal_bar.dart';
import '../../../widgets/menu_components/long_side_bar_widget.dart';
import 'menu_foods_items_screen.dart';

class MenuView extends StatelessWidget {
  const MenuView({super.key});

  @override
  Widget build(BuildContext context) {
    final List<MenuModel> model = [
      MenuModel(title: "Foods", cover: 'assets/images/food-menu.png', itemCount: 120, isHasMenu: true),
      MenuModel(title: "Beverages", cover: 'assets/images/beverages-menu.png', itemCount: 220, isHasMenu: false),
      MenuModel(title: "Desserts", cover: 'assets/images/desearts-menu.png', itemCount: 155, isHasMenu: false),
      MenuModel(title: "Promotions", cover: 'assets/images/promotions-menu.png', itemCount: 25, isHasMenu: false),
    ];

    return Column(
      children: [
        customAppbar(context, title: "Menu"),
        SizedBox(height: 14.h),
        CustomSearchBar(),
        SizedBox(height: 14.h),
        Expanded(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    longSideBar(),
                    ..._buildMenuItems(
                      30.h,
                      () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, SelectedMenuItemScreen()),
                      model[0],
                    ),
                    ..._buildMenuItems(140.h, () {}, model[1]),
                    ..._buildMenuItems(250.h, () {}, model[2]),
                    ..._buildMenuItems(360.h, () {}, model[3]),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

List<Widget> _buildMenuItems(double topOffset, void Function()? onTap, MenuModel model) {
  return [
    Positioned(
      left: 55.sp,
      top: topOffset,
      child: horizontalBar(onTap: onTap, title: model.title, count: model.itemCount.toString()),
    ),
    Positioned(
      left: 20.sp,
      top: topOffset,
      child: Container(
        height: 70.h,
        width: 70.w,
        decoration: BoxDecoration(
          color: Colors.transparent,
          image: DecorationImage(image: AssetImage(model.cover), fit: BoxFit.fitWidth),
        ),
      ),
    ),
    Positioned(
      right: 1.sp,
      top: topOffset + 25.h,
      child: Container(
        height: 30.h,
        width: 30.w,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 10, offset: Offset(0, 5))],
        ),
        child: Icon(Icons.watch_later_outlined, color: AppColor.orange, size: 20),
      ),
    ),
  ];
}
