import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';
import 'package:monkey_meal/src/model/item_model.dart';
import 'package:monkey_meal/src/screens/app/items/items_screen.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

import '../../../manage/foods/foods_cubit.dart';
import '../../../widgets/custom_list_tile/items_list_tile_widget.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  void initState() {
    super.initState();
    FirebaseServices().usersCollection.doc(FirebaseServices().currentUserId).collection('favorites').snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(context, title: "My Favourites"),
      body: StreamBuilder<QuerySnapshot>(
        stream:
            FirebaseServices().usersCollection
                .doc(FirebaseServices().currentUserId)
                .collection('favorites')
                .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Column(
                spacing: 10,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_sharp, color: Colors.grey, size: 65),
                  Text('No favorites yet', style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
                ],
              ),
            );
          }

          final favorites =
              snapshot.data!.docs.map((doc) {
                return ItemModel.fromMap(doc.data() as Map<String, dynamic>);
              }).toList();

          return ListView.builder(
            padding: const EdgeInsets.only(top: 10),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final item = favorites[index];
              return GestureDetector(
                onTap:
                    () => NavAndAnimationsFunctions.navToWithRTLAnimation(
                      context,
                      ItemsPage(
                        title: item.itemName,
                        description: item.itemDescription,
                        cover: item.itemCover,
                        rating: item.itemRating,
                        price: item.itemPrice,
                      ),
                    ),
                child: Dismissible(
                  key: Key(item.itemName),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed:
                      (direction) => BlocProvider.of<FoodsCubit>(
                        context,
                      ).toggleFavorite(context, FirebaseServices().currentUserId!, item),
                  child: itemListTile(
                    context,
                    title: item.itemName,
                    cover: item.itemCover,
                    rating: item.itemRating,
                    count: 120,
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
