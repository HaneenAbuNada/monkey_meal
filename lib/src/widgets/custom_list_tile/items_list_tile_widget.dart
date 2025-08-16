import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget itemListTile(
  context, {
  required String title,
  required String cover,
  required double rating,
  required int count,
}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10.0),
  child: Row(
    spacing: 20,
    children: [
      Expanded(
        flex: 1,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 70,
            height: 70,
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
        flex: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColor.primary)),
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
                const Icon(Icons.star, color: AppColor.orange, size: 16),
                Text(
                  rating.toString(),
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColor.orange),
                ),
                SizedBox(width: 4),
                Text(
                  "(${count.toString()} Ratings)",
                  style: const TextStyle(color: AppColor.placeholder, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  ),
);
