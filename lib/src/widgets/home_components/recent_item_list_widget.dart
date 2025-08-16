import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/src/screens/app/items/items_screen.dart';
import 'package:monkey_meal/src/widgets/custom_list_tile/items_list_tile_widget.dart';

import '../../manage/foods/foods_cubit.dart';

Widget recentItemsList(BuildContext context) {
  return BlocProvider(
    create: (context) => FoodsCubit()..fetchFoods(),
    child: BlocBuilder<FoodsCubit, FoodsState>(
      builder: (context, state) {
        if (state is SuccessLoadFood) {
          final recentItems = state.foods.take(3).toList();

          return SizedBox(
            height: 350,
            child: ListView.builder(
              itemCount: recentItems.length,
              itemBuilder: (context, index) {
                final item = recentItems[index];
                return GestureDetector(
                  onTap:
                      () => NavAndAnimationsFunctions.navToWithRTLAnimation(
                        context,
                        ItemsPage(
                          title: item.itemName,
                          description: item.itemDescription,
                          cover: item.itemCover,
                          rating: item.itemRating,
                          price: item.itemPrice,
                        ),
                      ),
                  child: itemListTile(
                    context,
                    title: item.itemName,
                    cover: item.itemCover,
                    rating: item.itemRating,
                    count: 120,
                  ),
                );
              },
              physics: const NeverScrollableScrollPhysics(),
            ),
          );
        } else if (state is LoadFoodLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is FailedLoadFood) {
          return Center(child: Text('Error: ${state.message}'));
        }
        return const SizedBox();
      },
    ),
  );
}
