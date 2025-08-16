import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/order_components/row_widget.dart';

Widget orderSummaryWidget({required double subtotal, required double delivery, required double total}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 16.0),
  child: Column(
    spacing: 5,
    children: [
      rowWidget(title: 'Delivery Instructions', post: '+ Add Notes'),
      SizedBox(height: 5),
      SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
      SizedBox(height: 5),
      rowWidget(title: 'sub total', post: '\$$subtotal'),
      rowWidget(title: 'Delivery Cost', post: '\$${delivery.toStringAsFixed(2)}'),
      SizedBox(height: 5),
      SizedBox(height: 2, child: Divider(color: Colors.grey.shade500)),
      SizedBox(height: 5),
      rowWidget(title: 'Total', post: '\$${total.toStringAsFixed(2)}'),
    ],
  ),
);
