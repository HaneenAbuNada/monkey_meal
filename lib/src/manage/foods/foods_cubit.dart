import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:monkey_meal/src/widgets/custom_snackbar/build_custom_snackbar_widget.dart';

import '../../../core/helper/firebase_helper.dart';
import '../../../core/helper/sqlite_helper.dart';
import '../../model/item_model.dart';
import '../../model/offer_item_model.dart';
import '../../model/order_model.dart';

part 'foods_state.dart';

class FoodsCubit extends Cubit<FoodsState> {
  final SqliteHelper _sqliteHelper = SqliteHelper(); // SQLite helper instance

  FoodsCubit() : super(FoodsInitial());

  static FoodsCubit get(context) => BlocProvider.of(context, listen: false);

  Future<void> fetchFoods() async {
    emit(LoadFoodLoading());
    try {
      // First try to get from local database
      final localFoods = await _sqliteHelper.getAllItems();
      if (localFoods.isNotEmpty) {
        emit(SuccessLoadFood(localFoods));
      }

      // Then get from Firebase and update local
      final foods = await FirebaseServices().getFoods();

      // Cache foods in SQLite
      for (final food in foods) {
        await _sqliteHelper.insertItem(food);
      }

      emit(SuccessLoadFood(foods));
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");

      // Fallback to local data if available
      final localFoods = await _sqliteHelper.getAllItems();
      if (localFoods.isNotEmpty) {
        emit(SuccessLoadFood(localFoods));
      } else {
        emit(FailedLoadFood(e.toString()));
      }
    }
  }

  Future<void> loadOffers() async {
    emit(LoadOffersLoading());
    try {
      // Currently offers are only from Firebase
      final offers = await FirebaseServices().getOffers();
      emit(SuccessOffersLoaded(offers));
    } catch (e, s) {
      debugPrint("Error: $e");
      debugPrint("StackTrace: $s");
      emit(FailedOffersError(e.toString()));
    }
  }

  Future<void> toggleFavorite(context, String userId, ItemModel item) async {
    try {
      // Check both Firebase and local DB for favorite status
      final isFavFirebase = await FirebaseServices().isFavorite(userId, item.itemName);
      final isFavLocal = await _sqliteHelper.isFavorite(userId, item.itemName);
      final isFav = isFavFirebase || isFavLocal;

      if (isFav) {
        showSuccessSnackBar('Removed from Favourite!', 3, context);
        await FirebaseServices().removeFromFavorites(userId, item.itemName);
        await _sqliteHelper.removeFavorite(userId, item.itemName);
      } else {
        showSuccessSnackBar('Added to Favourite!', 3, context);
        await FirebaseServices().addToFavorites(userId, item);
        await _sqliteHelper.addFavorite(userId, item.itemName);
      }

      updateFavoriteStatus(!isFav);
    } catch (e, s) {
      debugPrint("Error toggling favorite: $e");
      debugPrint("Error toggling favorite: $s");
      rethrow;
    }
  }

  Future<void> addItemToOrder(String userId, ItemModel item, int quantity) async {
    try {
      // Create order in Firebase
      await FirebaseServices().addToOrder(userId, item, quantity);

      // Create local order record
      final order = OrderModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        itemName: item.itemName,
        itemDescription: item.itemDescription,
        itemCover: item.itemCover,
        itemRating: item.itemRating,
        itemPrice: item.itemPrice,
        quantity: quantity,
        orderedAt: DateTime.now(),
        status: 'pending',
      );

      await _sqliteHelper.insertOrder(order);
    } catch (e, s) {
      debugPrint("Error adding to order: $e");
      debugPrint("Error adding to order: $s");
      rethrow;
    }
  }

  Future<void> fetchUserOrders(String userId) async {
    emit(OrdersLoading());
    try {
      // First try to get from local database
      final localOrders = await _sqliteHelper.getAllOrders();
      if (localOrders.isNotEmpty) {
        emit(OrdersLoaded(localOrders));
      }

      // Then get from Firebase
      final orders = await FirebaseServices().getUserOrders(userId);

      // Cache orders in SQLite
      for (final order in orders) {
        await _sqliteHelper.insertOrder(order);
      }

      emit(OrdersLoaded(orders));
    } catch (e) {
      // Fallback to local orders if available
      final localOrders = await _sqliteHelper.getAllOrders();
      if (localOrders.isNotEmpty) {
        emit(OrdersLoaded(localOrders));
      } else {
        emit(OrdersError(e.toString()));
      }
    }
  }

  Future<void> updateOrderStatus(String userId, String orderId, String status) async {
    try {
      // Update in Firebase
      await FirebaseServices().updateOrderStatus(userId, orderId, status);

      // Update in local database
      await _sqliteHelper.updateOrderStatus(orderId, status);

      // Update state
      final currentState = state;
      if (currentState is OrdersLoaded) {
        final updatedOrders =
            currentState.orders.map((order) {
              if (order.id == orderId) {
                return order.copyWith(status: status);
              }
              return order;
            }).toList();
        emit(OrdersLoaded(updatedOrders));
      }
    } catch (e) {
      emit(OrdersError(e.toString()));
    }
  }

  void increaseQuantity(int currentQuantity) {
    final newQuantity = currentQuantity + 1;
    emit(QuantityUpdated(newQuantity));
  }

  void decreaseQuantity(int currentQuantity) {
    if (currentQuantity > 1) {
      final newQuantity = currentQuantity - 1;
      emit(QuantityUpdated(newQuantity));
    }
  }

  void updateFavoriteStatus(bool isFavorite) {
    emit(FavoriteStatusUpdated(isFavorite));
  }

  @override
  Future<void> close() {
    return super.close();
  }
}
