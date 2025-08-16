import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/screens/app/items/items_screen.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../manage/foods/foods_cubit.dart';
import '../../../model/item_model.dart';
import '../../../widgets/custom_appbar/build_appbar.dart';
import '../../../widgets/custom_appbar/build_search_appbar.dart';

class SelectedMenuItemScreen extends StatelessWidget {
  const SelectedMenuItemScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodsCubit()..fetchFoods(),
      child: SafeArea(
        child: Scaffold(
          appBar: customAppbar(context, title: "Foods"),
          body: Column(
            children: [
              SizedBox(height: 14.h),
              const CustomSearchBar(),
              SizedBox(height: 14.h),
              Expanded(
                child: BlocBuilder<FoodsCubit, FoodsState>(
                  builder: (context, state) {
                    if (state is LoadFoodLoading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (state is FailedLoadFood) {
                      return Center(child: Text('Error: ${state.message}'));
                    } else if (state is SuccessLoadFood) {
                      return _buildFoodList(state.foods);
                    }
                    return const SizedBox(); // Initial state
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFoodList(List<ItemModel> foods) {
    return ListView.builder(
      itemCount: foods.length,
      itemBuilder: (context, index) {
        final food = foods[index];
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 3.0),
          child: GestureDetector(
            onTap:
                () => NavAndAnimationsFunctions.navToWithRTLAnimation(
                  context,
                  ItemsPage(
                    cover: food.itemCover,
                    rating: food.itemRating,
                    price: food.itemPrice.toDouble(),
                    description: food.itemDescription,
                    title: food.itemName,
                  ),
                ),
            child: Stack(
              children: [
                CachedNetworkImage(
                  imageUrl: food.itemCover,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) => Container(color: Colors.grey[200], height: 200, width: double.infinity),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[200],
                        height: 200,
                        width: double.infinity,
                        child: const Icon(Icons.error),
                      ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [Colors.black.withValues(alpha: 0.9), Colors.transparent],
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                    child: _menuItemData(title: food.itemName, rating: food.itemRating),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _menuItemData({required String title, required double rating, String? preparationTime}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white)),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.star, color: AppColor.orange, size: 16),
            const SizedBox(width: 4),
            Text(
              rating.toStringAsFixed(1),
              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500, color: AppColor.orange),
            ),
            const SizedBox(width: 8),
            Text(
              preparationTime ?? "Minute but old",
              style: const TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold),
            ),
            const Text(" . ", style: TextStyle(fontSize: 14, color: AppColor.orange, fontWeight: FontWeight.bold)),
            const Text("funFoods", style: TextStyle(fontSize: 14, color: Colors.white, fontWeight: FontWeight.bold)),
          ],
        ),
      ],
    );
  }
}
