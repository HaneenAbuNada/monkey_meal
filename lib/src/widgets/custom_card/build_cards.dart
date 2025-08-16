import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../../core/consts/colors/colors.dart';

Widget buildGeneralCard(
  BuildContext context, {
  required String cover,
  required String name,
  required String category,
  required String subCategory,
  required int ratingCount,
  required double ratingNumbers,
}) => Column(
  crossAxisAlignment: CrossAxisAlignment.start,
  children: [
    CachedNetworkImage(
      imageUrl: cover,
      height: 180,
      width: double.infinity,
      fit: BoxFit.cover,
      placeholder: (context, url) => Container(color: Colors.grey[200]),
      errorWidget: (context, url, error) => Center(child: Icon(Icons.network_wifi_1_bar_outlined, color: Colors.red)),
      memCacheWidth: (MediaQuery.of(context).size.width * 2).toInt(),
      maxWidthDiskCache: 1080,
    ),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.star, color: Colors.orange, size: 16),
              const SizedBox(width: 4),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: ratingNumbers.toString(),
                      style: const TextStyle(color: AppColor.orange, fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: ' ($ratingCount ratings)',
                      style: const TextStyle(color: AppColor.placeholder, fontWeight: FontWeight.bold),
                    ),
                    const TextSpan(text: '  '),
                    TextSpan(text: category, style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)),
                    const TextSpan(text: ' • ', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                    TextSpan(
                      text: subCategory,
                      style: const TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  ],
);
