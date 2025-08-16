import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';
import 'package:monkey_meal/src/widgets/home_components/most_popular_card_widget.dart';
import 'package:monkey_meal/src/widgets/home_components/popular_restaurants_list_widget.dart';
import 'package:monkey_meal/src/widgets/home_components/recent_item_list_widget.dart';

import '../../../widgets/custom_appbar/build_search_appbar.dart';
import '../../../widgets/home_components/foods_type_widget.dart';
import '../../../widgets/home_components/restaurant_header.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  String? userName, address;
  final firebaseServices = FirebaseServices();

  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    try {
      final uid = firebaseServices.currentUserId;
      if (uid != null) {
        final userModel = await firebaseServices.getUser(uid);
        setState(() {
          userName = userModel.name;
          address = userModel.address;
        });
      }
    } catch (e) {
      print("Error loading user name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          customAppbar(context, title: "Good morning ${userName?.split(' ').first ?? ''}!"),
          SizedBox(height: 14),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              spacing: 4,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Delivireing to",
                  style: TextStyle(color: AppColor.placeholder, fontSize: 11, fontWeight: FontWeight.w500),
                ),
                Text(
                  address ?? "Current Address",
                  style: TextStyle(color: AppColor.secondary, fontSize: 16, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          CustomSearchBar(),
          SizedBox(height: 24),
          foodTypeList(),
          SizedBox(height: 46),
          restaurantHeader(title: "Popular Restaurants"),
          SizedBox(height: 24),
          restaurantList(),
          restaurantHeader(title: "Most Popular"),
          mostPopularRestaurantList(context),
          SizedBox(height: 16),
          restaurantHeader(title: "ٌRecent Items"),
          recentItemsList(context),
        ],
      ),
    );
  }
}
