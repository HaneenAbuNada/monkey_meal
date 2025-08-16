import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/core/consts/functions/animations.dart';
import 'package:monkey_meal/core/helper/firebase_helper.dart';
import 'package:monkey_meal/src/manage/foods/foods_cubit.dart';
import 'package:monkey_meal/src/widgets/custom_appbar/build_appbar.dart';
import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
import 'package:monkey_meal/src/widgets/order_components/order_summary_widget.dart';

import '../../../../core/consts/colors/colors.dart';
import '../../../widgets/order_components/order_list_tile_widget.dart';
import '../../../widgets/order_components/order_options_widget.dart';
import '../checkout/checkout_screen.dart';

class OrderScreen extends StatefulWidget {
  const OrderScreen({super.key});

  @override
  State<OrderScreen> createState() => _OrderScreenState();
}

class _OrderScreenState extends State<OrderScreen> {
  final firebaseServices = FirebaseServices();
  String? address = "";

  @override
  void initState() {
    super.initState();
    _loadAddress();
  }

  Future<void> _loadAddress() async {
    try {
      final uid = firebaseServices.currentUserId;
      if (uid != null) {
        final userModel = await firebaseServices.getUser(uid);
        setState(() {
          address = userModel.address;
        });
      }
    } catch (e) {
      print("Error loading user name: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => FoodsCubit()..fetchUserOrders(FirebaseServices().currentUserId!),
      child: Scaffold(
        appBar: customAppbar(context, title: 'My Order'),
        body: BlocBuilder<FoodsCubit, FoodsState>(
          builder: (context, state) {
            if (state is OrdersLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is OrdersLoaded) {
              final hasOrders = state.orders.isNotEmpty;
              final double subtotal = state.orders.fold(
                0.0,
                (sum, order) => sum + (order.itemPrice * order.quantity) + 25,
              );
              final deliveryFee = 5.0;
              final total = subtotal + deliveryFee;

              return Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          if (hasOrders) ...[
                            ...state.orders.map((order) {
                              return orderListTile(
                                context,
                                title: order.itemName,
                                cover: order.itemCover,
                                rating: order.itemRating,
                                count: order.quantity,
                                address: address ?? "Address",
                              );
                            }),
                            orderOptions(),
                            orderSummaryWidget(subtotal: subtotal, delivery: deliveryFee, total: total),
                          ] else ...[
                            Padding(
                              padding: const EdgeInsets.only(top: 100),
                              child: Column(
                                children: [
                                  Icon(Icons.shopping_cart_outlined, size: 100, color: Colors.grey[400]),
                                  SizedBox(height: 20),
                                  Text(
                                    'No Orders Yet',
                                    style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  Text(
                                    'Your cart is empty',
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.grey[500],
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
                    child: customButton(
                      title: 'Checkout',
                      color: hasOrders ? AppColor.orange : CupertinoColors.systemGrey3,
                      press:
                          hasOrders
                              ? () => NavAndAnimationsFunctions.navToWithRTLAnimation(
                                context,
                                CheckoutScreen(
                                  currentAddress: address ?? "Address",
                                  subTotal: subtotal.toStringAsFixed(2),
                                  total: (total - 14).toStringAsFixed(2),
                                ),
                              )
                              : () {},
                    ),
                  ),
                ],
              );
            } else if (state is OrdersError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return SizedBox();
          },
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:monkey_meal/core/consts/functions/animations.dart';
// import 'package:monkey_meal/core/helper/firebase_helper.dart';
// import 'package:monkey_meal/src/manage/foods/foods_cubit.dart';
// import 'package:monkey_meal/src/widgets/custom_button/build_custom_button.dart';
// import 'package:monkey_meal/src/widgets/order_components/order_summary_widget.dart';
//
// import '../../../widgets/order_components/order_list_tile_widget.dart';
// import '../../../widgets/order_components/order_options_widget.dart';
// import '../checkout/checkout_screen.dart';
//
// class OrderScreen extends StatefulWidget {
//   const OrderScreen({super.key});
//
//   @override
//   State<OrderScreen> createState() => _OrderScreenState();
// }
//
// class _OrderScreenState extends State<OrderScreen> {
//   final firebaseServices = FirebaseServices();
//   String? address = "";
//
//   @override
//   void initState() {
//     super.initState();
//     _loadAddress();
//   }
//
//   Future<void> _loadAddress() async {
//     try {
//       final uid = firebaseServices.currentUserId;
//       if (uid != null) {
//         final userModel = await firebaseServices.getUser(uid);
//         setState(() {
//           address = userModel.address;
//         });
//       }
//     } catch (e) {
//       print("Error loading user name: $e");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return BlocProvider(
//       create: (context) => FoodsCubit()..fetchUserOrders(FirebaseServices().currentUserId!),
//       child: Scaffold(
//         appBar: AppBar(title: Text('My Order', style: TextStyle(fontWeight: FontWeight.bold))),
//         body: BlocBuilder<FoodsCubit, FoodsState>(
//           builder: (context, state) {
//             if (state is OrdersLoading) {
//               return Center(child: CircularProgressIndicator());
//             } else if (state is OrdersLoaded) {
//               final double subtotal = state.orders.fold(
//                 0.0,
//                 (sum, order) => sum + (order.itemPrice * order.quantity) + 25,
//               );
//               final deliveryFee = 5.0;
//               final total = subtotal + deliveryFee;
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     ...state.orders.map((order) {
//                       return orderListTile(
//                         context,
//                         title: order.itemName,
//                         cover: order.itemCover,
//                         rating: order.itemRating,
//                         count: order.quantity,
//                         address: address ?? "Address",
//                       );
//                     }),
//                     orderOptions(),
//                     orderSummaryWidget(subtotal: subtotal, delivery: deliveryFee, total: total),
//                     SizedBox(height: 30),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 20.0),
//                       child: customButton(
//                         title: 'Checkout',
//                         press:
//                             () => NavAndAnimationsFunctions.navToWithRTLAnimation(
//                               context,
//                               CheckoutScreen(
//                                 currentAddress: address ?? "Address",
//                                 subTotal: subtotal.toStringAsFixed(2),
//                                 total: (total - 14).toStringAsFixed(2),
//                               ),
//                             ),
//                       ),
//                     ),
//                     SizedBox(height: 10),
//                   ],
//                 ),
//               );
//             } else if (state is OrdersError) {
//               return Center(child: Text('Error: ${state.message}'));
//             }
//             return SizedBox();
//           },
//         ),
//       ),
//     );
//   }
// }
