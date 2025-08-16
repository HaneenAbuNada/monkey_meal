import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget orderListTile(
  context, {
  required String title,
  required String cover,
  required String address,
  required double rating,
  required int count,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
  child: Row(
    spacing: 20,
    children: [
      Expanded(
        flex: 2,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 90,
            height: 90,
            child: CachedNetworkImage(
              imageUrl: cover,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(color: Colors.grey[200]),
              errorWidget:
                  (context, url, error) => Center(child: Icon(Icons.network_wifi_1_bar_outlined, color: Colors.red)),
              memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
              maxWidthDiskCache: 1080,
            ),
          ),
        ),
      ),
      Expanded(
        flex: 4,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              spacing: 5,
              children: [
                Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primary)),
                Text(
                  "(${count.toString()} items)",
                  style: const TextStyle(color: AppColor.placeholder, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            SizedBox(height: 4),
            Row(
              children: [
                const Icon(Icons.star, color: Colors.orange, size: 16),
                SizedBox(width: 2),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColor.orange),
                ),
              ],
            ),
            SizedBox(height: 4),
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(text: 'Café', style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                  const TextSpan(text: ' • ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                  TextSpan(
                    text: 'Western Food',
                    style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.location_on, color: AppColor.orange, size: 16),
                SizedBox(width: 4),
                Text(
                  address,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
