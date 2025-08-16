import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';
import '../../model/item_model.dart';

Widget mostPopularRestaurantList(context) {
  final List<ItemModel> mostPopularRestaurantList = [
    ItemModel(
      itemName: "Burger by Bella",
      itemDescription: "American Fast Food",
      itemCover: "https://bellachickenandburger.com/wp-content/uploads/2024/10/Bella-New-One.jpg",
      itemRating: 5.0,
      itemPrice: 12,
    ),
    ItemModel(
      itemName: "Café De Bambaa",
      itemDescription: "Western Food",
      itemCover:
          "https://i0.wp.com/uofan.com/wp-content/uploads/2023/01/cafe-la-bamba-featured.jpg?resize=860%2C484&ssl=1",
      itemRating: 4.0,
      itemPrice: 15,
    ),
  ];
  return SizedBox(
    height: 250,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: mostPopularRestaurantList.length,
      itemBuilder: (context, index) {
        final restaurant = mostPopularRestaurantList[index];
        return SizedBox(width: MediaQuery.of(context).size.width * 0.8, child: mostPopularCard(context, restaurant));
      },
    ),
  );
}

Widget mostPopularCard(context, ItemModel restaurant) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: 180,
          width: MediaQuery.of(context).size.width * 0.8 - 24,
          child: CachedNetworkImage(
            imageUrl: restaurant.itemCover,
            width: double.infinity,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(color: Colors.grey[200]),
            errorWidget:
                (context, url, error) => Center(child: Icon(Icons.network_wifi_1_bar_outlined, color: Colors.red)),
            memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
            maxWidthDiskCache: 1080,
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              restaurant.itemName,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primary),
            ),
            Row(
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(text: 'Café', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                      const TextSpan(text: ' • ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: restaurant.itemDescription,
                        style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                      ),
                      WidgetSpan(child: SizedBox(width: 30)),
                      TextSpan(
                        text: restaurant.itemRating.toString(),
                        style: const TextStyle(color: AppColor.orange, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 2),
                const Icon(Icons.star, color: Colors.orange, size: 16),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
