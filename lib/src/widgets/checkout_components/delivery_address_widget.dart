import 'package:flutter/material.dart';

import '../../../core/consts/functions/animations.dart';
import 'map_and_address_widget.dart';

Widget deliveryAddressWidget(context, String currentAddress) => Padding(
  padding: const EdgeInsets.all(16.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.w300, fontSize: 16)),
      SizedBox(height: 8),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(currentAddress, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          InkWell(
            onTap: () => NavAndAnimationsFunctions.navToWithRTLAnimation(context, ChangeAddressScreen()),
            child: Text('Change', style: TextStyle(color: Colors.orange)),
          ),
        ],
      ),
    ],
  ),
);
