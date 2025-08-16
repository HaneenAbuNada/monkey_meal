import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/colors/colors.dart';
import 'package:monkey_meal/src/manage/foods/foods_cubit.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';

import '../../../../core/consts/functions/animations.dart';
import '../../../model/offer_item_model.dart';
import '../../../widgets/custom_card/build_cards.dart';
import '../items/items_screen.dart';

class OfferView extends StatelessWidget {
  const OfferView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodsCubit()..loadOffers(),
      child: Scaffold(
        appBar: customAppbar(context, title: "Latest Offers"),
        body: BlocBuilder<FoodsCubit, FoodsState>(
          builder: (context, state) {
            if (state is LoadOffersLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is FailedOffersError) {
              return Center(child: Text(state.message));
            } else if (state is SuccessOffersLoaded) {
              return _buildOfferContent(context, state.offers);
            }
            return const Center(child: Text('No offers available'));
          },
        ),
      ),
    );
  }

  Widget _buildOfferContent(BuildContext context, List<OfferItemModel> offers) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Find discounts, Offers special\nmeals and more!',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 10),
            Container(
              height: 40,
              width: 200,
              decoration: BoxDecoration(color: AppColor.orange, borderRadius: BorderRadius.circular(30)),
              child: const Center(
                child: Text("Check Offers", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
      Expanded(
        child: ListView.separated(
          separatorBuilder: (context, index) => const SizedBox(height: 8),
          itemCount: offers.length,
          itemBuilder: (context, index) {
            final offer = offers[index];
            return InkWell(
              onTap:
                  () => NavAndAnimationsFunctions.navToWithRTLAnimation(
                    context,
                    ItemsPage(
                      title: offer.offerName,
                      description: offer.offerDescription,
                      price: offer.offerNewPrice,
                      rating: offer.offerRatingCount,
                      cover: offer.offerCover,
                    ),
                  ),
              child: buildGeneralCard(
                context,
                cover: offer.offerCover,
                name: offer.offerName,
                category: offer.offerCategory,
                subCategory: offer.offerSubCategory,
                ratingCount: offer.offerRatingNumbers.toInt(),
                ratingNumbers: offer.offerRatingCount,
              ),
            );
          },
        ),
      ),
    ],
  );
}
