import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:monkey_meal/src/model/category_model.dart';

import '../../../core/consts/colors/colors.dart';

Widget foodTypeList() => Padding(
  padding: const EdgeInsets.all(14.0),
  child: SizedBox(
    height: 130,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: foodTypes.length,
      itemBuilder: (context, index) => foodTypeCard(imagePath: foodTypes[index].imageUrl, title: foodTypes[index].name),
    ),
  ),
);

Widget foodTypeCard({required String imagePath, required String title}) => Padding(
  padding: const EdgeInsets.symmetric(horizontal: 8.0),
  child: Column(
    spacing: 8,
    children: [
      // Container(
      //   height: 100,
      //   width: 100,
      //   decoration: BoxDecoration(
      //     borderRadius: BorderRadius.circular(12),
      //     image: DecorationImage(image: AssetImage(imagePath), fit: BoxFit.cover),
      //     boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2))],
      //   ),
      // ),
      CachedNetworkImage(
        imageUrl: imagePath,
        imageBuilder:
            (context, imageProvider) => Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
                boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
              ),
            ),
        placeholder:
            (context, url) => Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
              child: const Center(child: CircularProgressIndicator()),
            ),
        errorWidget:
            (context, url, error) => Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(12), color: Colors.grey[200]),
              child: const Icon(Icons.error, color: Colors.red),
            ),
        memCacheHeight: 200,
        memCacheWidth: 200,
      ),
      Text(
        title,
        style: TextStyle(color: AppColor.primary, fontSize: 14, fontWeight: FontWeight.bold),
        textAlign: TextAlign.center,
      ),
    ],
  ),
);
