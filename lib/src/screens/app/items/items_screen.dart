import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';
import 'package:monkey_meal/src/manage/foods/foods_cubit.dart';
import 'package:monkey_meal/src/screens/app/payments/payment_screen.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../model/item_model.dart';
import '../../../widgets/items_components/build_items_content_widget.dart';
import '../../../widgets/items_components/favourite_button.dart';

class ItemsPage extends StatefulWidget {
  final String title, description, cover;
  final double rating, price;

  const ItemsPage({
    super.key,
    required this.title,
    required this.description,
    required this.cover,
    required this.rating,
    required this.price,
  });

  @override
  State<ItemsPage> createState() => _ItemsPageState();
}

class _ItemsPageState extends State<ItemsPage> {
  @override
  Widget build(BuildContext context) {
    int quantity = 1;
    bool isFavorite = false;
    final String userId = FirebaseServices().currentUserId.toString();
    final item = ItemModel(
      itemName: widget.title,
      itemCover: widget.cover,
      itemRating: widget.rating,
      itemPrice: widget.price.toDouble(),
      itemDescription: widget.description,
    );

    return BlocBuilder<FoodsCubit, FoodsState>(
      builder: (context, state) {
        final cubit = FoodsCubit.get(context);
        if (state is QuantityUpdated) {
          quantity = state.newQuantity;
        }
        if (state is FavoriteStatusUpdated) {
          isFavorite = state.isFavorite;
        }

        return Scaffold(
          body: Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 320,
                child: CachedNetworkImage(
                  imageUrl: widget.cover,
                  // "https://img.taste.com.au/c0IPU6rJ/w643-h428-cfill-q90/taste/2016/11/tandoori-chicken-pizza-60718-1.jpeg",
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 40,
                right: 16,
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: IconButton(
                    onPressed: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, PaymentScreen()),
                    icon: Icon(Icons.shopping_cart_outlined, color: AppColor.orange),
                  ),
                ),
              ),
              Positioned(
                top: 40,
                left: 16,
                child: InkWell(
                  onTap: () => Navigator.pop(context),
                  child: CircleAvatar(
                    backgroundColor: Colors.white,
                    child: Icon(Icons.arrow_back_sharp, color: AppColor.orange),
                  ),
                ),
              ),
              Positioned.fill(
                top: 250,
                child: buildItemContent(
                  title: widget.title,
                  description: widget.description,
                  rating: widget.rating,
                  price: widget.price,
                  quantity: quantity,
                  onCrease: () => cubit.increaseQuantity(quantity),
                  onDecrease: () {
                    if (quantity > 1) {
                      cubit.decreaseQuantity(quantity);
                    }
                  },
                  addToCardFunction: () async {
                    try {
                      await context.read<FoodsCubit>().addItemToOrder(userId, item, quantity);
                      showSuccessSnackBar("Added To Order!", 3, context);
                    } catch (e) {
                      showErrorSnackBar('Error: ${e.toString()}', 3, context);
                    }
                  },
                ),
              ),
              Positioned(
                top: 200,
                right: 8,
                child: GestureDetector(
                  onTap: () async {
                    try {
                      await cubit.toggleFavorite(context, userId, item);
                      cubit.updateFavoriteStatus(!isFavorite);
                    } catch (e) {
                      showErrorSnackBar('Error: ${e.toString()}', 3, context);
                    }
                  },
                  child: buildFavouriteWidget(isFavorite: isFavorite),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
