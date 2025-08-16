import 'package:flutter/material.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/src/widgets/items_components/build_counter_widget.dart';
import 'package:monkey_meal/src/widgets/items_components/build_price_card_widget.dart';

import 'build_drop_down_widget.dart';

Widget buildItemContent({
  required String title,
  required String description,
  required double rating,
  required double price,
  required int quantity,
  required void Function() onCrease,
  required void Function() onDecrease,
  required void Function() addToCardFunction,
}) => Container(
  decoration: const BoxDecoration(color: Colors.white, borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
  child: SingleChildScrollView(
    padding: const EdgeInsets.only(bottom: 10),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 18.0, left: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Row(
                children: [
                  Row(
                    children: List.generate(5, (index) {
                      return Icon(
                        index < rating.round() ? Icons.star : Icons.star_border,
                        color: AppColor.orange,
                        size: 18,
                      );
                    }),
                  ),
                  const SizedBox(width: 6),
                  Text("${rating.toDouble()} Star rating", style: TextStyle(fontSize: 14, color: AppColor.orange)),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 28.0),
          child: Align(
            alignment: AlignmentDirectional.topEnd,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Rs. $price",
                  style: TextStyle(fontSize: 35, fontWeight: FontWeight.bold, color: AppColor.primary),
                ),
                const Text("/ per Portion", style: TextStyle(fontSize: 15, color: Colors.black)),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 8.0, top: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Description",
                style: TextStyle(fontSize: 18, color: Colors.black, fontWeight: FontWeight.bold),
              ),
              Text(description, style: TextStyle(fontSize: 14, color: Colors.grey)),
            ],
          ),
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 25, bottom: 20),
              child: const Text("Customize your Order", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            buildDropdown("Select the size of portion"),
            SizedBox(height: 10),
            buildDropdown("Select the ingredients"),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 60, bottom: 40),
              child: const Text("Number of Portions", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 8.0, top: 60, bottom: 40),
              child: Row(
                children: [
                  buildRoundButton(Icons.remove, onDecrease),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(quantity.toString(), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  ),
                  buildRoundButton(Icons.add, onCrease),
                ],
              ),
            ),
          ],
        ),
        SizedBox(
          height: 220,
          width: double.infinity,
          child: priceCardWidget(totalPrice: (price * quantity), addToCardFunction: addToCardFunction),
        ),
      ],
    ),
  ),
);
