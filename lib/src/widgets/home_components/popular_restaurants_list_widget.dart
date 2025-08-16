import 'package:flutter/material.dart';
import 'package:monkey_meal/src/model/item_model.dart';
import 'package:monkey_meal/src/widgets/custom_card/build_cards.dart';

Widget restaurantList() {
  final List<ItemModel> restaurantList = [
    ItemModel(
      itemName: "Burger King",
      itemDescription: "American Fast Food",
      itemCover: "https://i.insider.com/5bd2234bdde867488579161f?width=1000&format=jpeg&auto=webp",
      itemRating: 4.5,
      itemPrice: 12,
    ),
    ItemModel(
      itemName: "Pizza Palace",
      itemDescription: "Italian Food",
      itemCover:
          "https://assets.simpleviewinc.com/simpleview/image/upload/c_limit,q_75,w_1200/v1/crm/knoxville/IMG_10130-15611ee65056a34_15612034-5056-a348-3a2d881fc88a018b.jpg",
      itemRating: 4.7,
      itemPrice: 15,
    ),
    ItemModel(
      itemName: "Sushi Master",
      itemDescription: "Chinese Food",
      itemCover:
          "https://media.istockphoto.com/id/1136673990/photo/master-chef-holding-chopsticks-with-flying-sushi.webp?s=1024x1024&w=is&k=20&c=owTcALAmcmEEasQrYK1DQQj-wLOJ4jJefDwlOK26in8=",
      itemRating: 4.8,
      itemPrice: 20,
    ),
    ItemModel(
      itemName: "Taco Haven",
      itemDescription: "Mexican Food",
      itemCover:
          "https://visitoxnard.com/imager/files_idss_com/C251/90268330-7eaa-41f0-abbd-a00d846b47b2_50332489631ede5899154173a03886f1.jpg",
      itemRating: 4.4,
      itemPrice: 10,
    ),
    ItemModel(
      itemName: "Pasta Corner",
      itemDescription: "Italian Food",
      itemCover:
          "https://static.wixstatic.com/media/cf04a2_eb0292513be248a4a39f3bd1abb30669~mv2.jpg/v1/fill/w_1351,h_812,al_c,q_85,usm_0.66_1.00_0.01,enc_avif,quality_auto/cf04a2_eb0292513be248a4a39f3bd1abb30669~mv2.jpg",
      itemRating: 4.6,
      itemPrice: 14,
    ),
  ];

  return SizedBox(
    height: 1300,
    child: ListView.builder(
      physics: NeverScrollableScrollPhysics(),
      itemCount: restaurantList.length,
      itemBuilder: (context, index) {
        final restaurant = restaurantList[index];
        return buildGeneralCard(
          context,
          cover: restaurant.itemCover,
          name: restaurant.itemName,
          category: 'Café',
          subCategory: restaurant.itemDescription,
          ratingCount: 100,
          ratingNumbers: restaurant.itemRating,
        );
      },
    ),
  );
}
