import 'package:flutter/material.dart';
import 'package:monkey_meal/src/widgets/order_components/row_widget.dart';

Widget buildFinalPayDetailsWidget({required String subTotal, required String total}) => Column(
  children: [
    rowWidget(title: 'Sub Total', post: '\$$subTotal'),
    SizedBox(height: 8),
    rowWidget(title: 'Delivery Cost', post: '\$5'),
    SizedBox(height: 8),
    rowWidget(title: 'Discount', post: '-\$14'),
    SizedBox(height: 8),
    SizedBox(child: Divider(color: Colors.grey.shade300, thickness: 1)),
    SizedBox(height: 8),
    rowWidget(title: 'Total', post: '\$$total'),
    SizedBox(height: 32),
  ],
);
